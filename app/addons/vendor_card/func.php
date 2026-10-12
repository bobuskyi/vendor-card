<?php

use Tygh\Tygh;
use Tygh\Registry;

if (!defined('BOOTSTRAP')) {
    die('Access denied');
}

/**
 * Build one view model for both presentations. Only active vendors are shown.
 * A positive block setting selects a fixed vendor; 0 uses the current page.
 */
function fn_vendor_card_get_vendor($configured_company_id = 0)
{
    $configured_company_id = trim((string) $configured_company_id);
    if ($configured_company_id !== '' && $configured_company_id !== '0') {
        if (!ctype_digit($configured_company_id)) {
            return [];
        }
        $company_id = (int) $configured_company_id;
    } else {
        $product = Tygh::$app['view']->getTemplateVars('product');
        $company = Tygh::$app['view']->getTemplateVars('company_data');
        $company_id = !empty($product['company_id'])
            ? (int) $product['company_id']
            : (int) ($company['company_id'] ?? 0);
    }

    if ($company_id <= 0) {
        return [];
    }

    $company = fn_get_company_data($company_id, CART_LANGUAGE);
    if (!$company || ($company['status'] ?? '') !== 'A') {
        return [];
    }

    $name = trim((string) ($company['company'] ?? ''));
    if ($name === '') {
        return [];
    }

    $logos = fn_get_logos($company_id);
    $avatar = (string) ($logos['theme']['image']['image_path'] ?? '');
    if ($avatar !== '' && !preg_match('~^(?:https?://|/)~i', $avatar)) {
        $avatar = '';
    }

    $website = fn_vendor_card_website($company['url'] ?? '');
    // Keep the entire seller description for the dialog; only the inline cover is shortened.
    $description_full = fn_vendor_card_plain_text($company['company_description'] ?? '');
    $description = $description_full;
    if (mb_strlen($description, 'UTF-8') > 600) {
        $description = rtrim(mb_substr($description, 0, 600, 'UTF-8')) . '…';
    }

    $location = array_filter([
        trim((string) ($company['city'] ?? '')),
        !empty($company['country']) ? fn_get_country_name($company['country'], CART_LANGUAGE) : '',
    ], 'strlen');

    // Optional public information: never invent ratings or verification status.
    $registered_at = isset($company['timestamp']) && is_numeric($company['timestamp'])
        ? (int) $company['timestamp']
        : 0;
    $member_since = $registered_at > 0 ? date('M Y', $registered_at) : '';

    $rating = null;
    if (isset($company['average_rating']) && is_numeric($company['average_rating'])) {
        $value = (float) $company['average_rating'];
        if ($value > 0 && $value <= 5) {
            $rating = number_format($value, 1, '.', '');
        }
    }

    // Read actual marketplace data first. Missing capabilities remain null, not invented.
    $metrics = fn_vendor_card_get_metrics($company_id, (int) ($company['plan_id'] ?? 0));
    $demo_profile = fn_vendor_card_demo_profile($company);

    return [
        'is_demo' => !empty($demo_profile),
        'plan_name' => $metrics['plan_name'],
        // Demo-only badges are used only when explicitly enabled by the local fixture.
        'is_pro' => !empty($demo_profile['is_pro']),
        'is_verified' => !empty($demo_profile['is_verified']),
        'is_online' => !empty($demo_profile['is_online']),
        'response_time' => (string) ($demo_profile['response_time'] ?? ''),
        'positive_percent' => $demo_profile['positive_percent'] ?? $metrics['positive_percent'],
        'reviews_count' => $demo_profile['reviews_count'] ?? $metrics['reviews_count'],
        'orders_count' => $demo_profile['orders_count'] ?? $metrics['orders_count'],
        'member_since' => $member_since ?: ($demo_profile['member_since'] ?? ''),
        'rating' => $demo_profile['rating'] ?? ($rating ?: $metrics['rating']),
        'company_id' => $company_id,
        'name' => $name,
        'initials' => fn_vendor_card_initials($name),
        'avatar_url' => $avatar,
        'description' => $description,
        'description_full' => $description_full,
        'location' => implode(', ', $location),
        'website_url' => $website,
        'website_label' => $website ? (string) parse_url($website, PHP_URL_HOST) : '',
        'profile_url' => fn_url('companies.view?company_id=' . $company_id),
    ];
}

/**
 * Fetch actual plan and metrics using the standard database API.
 * A null result means that a metric is unavailable, whereas 0 means a real zero.
 * Restrict vendor reviews to approved ratings on vendor discussion threads.
 * Count completed child/non-parent orders only, to avoid double-counting.
 */
function fn_vendor_card_get_metrics($company_id, $plan_id)
{
    $metrics = [
        'plan_name' => '',
        'positive_percent' => null,
        'reviews_count' => null,
        'orders_count' => null,
        'rating' => null,
    ];

    if ($plan_id > 0 && Registry::get('addons.vendor_plans.status') === 'A') {
        $plan_name = db_get_field(
            'SELECT plan FROM ?:vendor_plan_descriptions WHERE plan_id = ?i AND lang_code = ?s',
            $plan_id,
            CART_LANGUAGE
        );
        if (!$plan_name && CART_LANGUAGE !== 'en') {
            $plan_name = db_get_field(
                'SELECT plan FROM ?:vendor_plan_descriptions WHERE plan_id = ?i AND lang_code = ?s',
                $plan_id,
                'en'
            );
        }
        $metrics['plan_name'] = trim((string) $plan_name);
    }

    // Only the add-on providing the tables and rating semantics can be used.
    if (Registry::get('addons.discussion.status') === 'A') {
        $reviews = db_get_row(
            'SELECT COUNT(DISTINCT r.post_id) AS reviews_count,'
            . ' AVG(CASE WHEN r.rating_value BETWEEN 1 AND 5 THEN r.rating_value ELSE NULL END) AS avg_rating,'
            . ' SUM(CASE WHEN r.rating_value BETWEEN 1 AND 5 THEN 1 ELSE 0 END) AS rated_count,'
            . ' SUM(CASE WHEN r.rating_value >= 4 AND r.rating_value <= 5 THEN 1 ELSE 0 END) AS positive_count'
            . ' FROM ?:discussion AS d'
            . ' JOIN ?:discussion_posts AS p ON p.thread_id = d.thread_id AND p.status = ?s'
            . ' JOIN ?:discussion_rating AS r ON r.post_id = p.post_id AND r.thread_id = d.thread_id'
            . ' WHERE d.object_type = ?s AND d.object_id = ?i',
            'A',
            'M',
            $company_id
        );
        $metrics['reviews_count'] = (int) ($reviews['reviews_count'] ?? 0);
        if (!empty($reviews['rated_count']) && is_numeric($reviews['avg_rating'])) {
            $metrics['rating'] = number_format((float) $reviews['avg_rating'], 1, '.', '');
            $metrics['positive_percent'] = (int) round(100 * (int) $reviews['positive_count'] / (int) $reviews['rated_count']);
        }
    }

    $metrics['orders_count'] = (int) db_get_field(
        'SELECT COUNT(*) FROM ?:orders WHERE company_id = ?i AND status = ?s AND is_parent_order = ?s',
        $company_id,
        'C',
        'N'
    );

    return $metrics;
}

/** Keep vendor-authored HTML out of the shared details template. */
function fn_vendor_card_plain_text($value)
{
    $value = preg_replace('~<(script|style)\b[^>]*>.*?</\1>~is', '', (string) $value);
    $value = preg_replace('~<\s*(?:br\b[^>]*|/?(?:p|div|li|h[1-6])\b[^>]*)>~i', ' ', $value);
    $value = html_entity_decode(strip_tags($value), ENT_QUOTES | ENT_HTML5, 'UTF-8');

    return trim(preg_replace('/[\s\p{Z}]+/u', ' ', $value));
}

/** Unicode-safe initials: first and last word, or the first letter. */
function fn_vendor_card_initials($name)
{
    $words = preg_split('/[\s\p{Z}\-]+/u', trim($name), -1, PREG_SPLIT_NO_EMPTY);
    if (!$words) {
        return '?';
    }
    $initials = mb_substr($words[0], 0, 1, 'UTF-8');
    if (count($words) > 1) {
        $initials .= mb_substr($words[count($words) - 1], 0, 1, 'UTF-8');
    }

    return mb_strtoupper($initials, 'UTF-8');
}

/** Only render an external link when it has a valid HTTP(S) URL. */
function fn_vendor_card_website($value)
{
    $value = trim((string) $value);
    if ($value === '') {
        return '';
    }
    if (!preg_match('~^[a-z][a-z\d+.-]*:~i', $value)) {
        $value = 'https://' . ltrim($value, '/');
    }
    $parts = parse_url($value);
    if (!$parts || !in_array(strtolower($parts['scheme'] ?? ''), ['http', 'https'], true)
        || empty($parts['host']) || isset($parts['user']) || isset($parts['pass'])
        || !filter_var($value, FILTER_VALIDATE_URL)
    ) {
        return '';
    }

    return $value;
}


/**
 * Optional LOCAL DEMO ONLY. Profile data is not a verified CS-Cart metric.
 * No fixture is shipped inside the add-on or required in production.
 * Match only the explicit demo vendor's email; other vendors use actual data.
 */
function fn_vendor_card_demo_profile(array $company)
{
    $file = DIR_ROOT . '/var/files/vendor_card/demo_profile.json';
    if (!is_file($file) || !is_readable($file)) {
        return [];
    }

    $data = json_decode((string) file_get_contents($file), true);
    if (!is_array($data) || empty($data['vendor_email']) || empty($company['email'])
        || strcasecmp(trim((string) $data['vendor_email']), trim((string) $company['email'])) !== 0
    ) {
        return [];
    }

    $member_since = substr(trim(strip_tags((string) ($data['member_since'] ?? ''))), 0, 40);
    $response_time = substr(trim(strip_tags((string) ($data['response_time'] ?? ''))), 0, 40);

    $result = [
        'is_pro' => !empty($data['is_pro']),
        'is_verified' => !empty($data['is_verified']),
        'is_online' => !empty($data['is_online']),
        'member_since' => $member_since,
        'response_time' => $response_time,
    ];

    foreach (['positive_percent', 'reviews_count', 'orders_count'] as $key) {
        if (isset($data[$key]) && is_numeric($data[$key])) {
            $value = (int) $data[$key];
            if ($value >= 0 && $value <= ($key === 'positive_percent' ? 100 : 1000000000)) {
                $result[$key] = $value;
            }
        }
    }

    if (isset($data['rating']) && is_numeric($data['rating'])) {
        $rating = (float) $data['rating'];
        if ($rating >= 0 && $rating <= 5) {
            $result['rating'] = number_format($rating, 1, '.', '');
        }
    }

    return $result;
}
