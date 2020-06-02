{% if not var("enable_clearbit_enrichment_source") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}
WITH source AS (
  SELECT
  company__id,
 company__name,
 company__legalName,
 company__domain,
 company__domainAliases,
 company__site__phoneNumbers___,
 company__site__emailAddresses,
 company__category__sector,
 company__category__industryGroup,
 company__category__industry,
 company__category__subIndustry,
 company__category__sicCode,
 company__category__naicsCode,
 company__tags___,
 company__description,
 company__foundedYear,
 company__location,
 company__timeZone,
 company__utcOffset,
 company__geo__streetNumber,
 company__geo__streetName,
 company__geo__subPremise,
 company__geo__city,
 company__geo__postalCode,
 company__geo__state,
 company__geo__stateCode,
 company__geo__country,
 company__geo__countryCode,
 company__geo__lat,
 company__geo__lng,
 company__logo,
 company__facebook__handle,
 company__facebook__likes,
 company__linkedin__handle,
 company__twitter__handle,
 company__twitter__id,
 company__twitter__bio,
 company__twitter__followers,
 company__twitter__following,
 company__twitter__location,
 company__twitter__site,
 company__twitter__avatar,
 company__crunchbase__handle,
 company__emailProvider,
 company__type,
 company__ticker,
 company__identifiers__usEIN,
 company__phone,
 company__metrics__alexaUsRank,
 company__metrics__alexaGlobalRank,
 company__metrics__employees,
 company__metrics__employeesRange,
 company__metrics__marketCap,
 company__metrics__raised,
 company__metrics__annualRevenue,
 company__metrics__estimatedAnnualRevenue,
 company__metrics__fiscalYearEnd,
 company__indexedAt,
 company__tech,
 company__techCategories,
 company__parent__domain,
 company__ultimateParent__domain
  FROM
   {{ target.database}}.{{ var('clearbit_schema') }}.{{ var('clearbit_companies_table') }}
 where company__id is not null 
   {{ dbt_utils.group_by(62) }}
),
renamed as (
  SELECT
  concat('{{ var('id-prefix') }}',company__id) as company_enrichment_id,
  company__name as company_enrichment_name,
  company__legalName as company_enrichment_legalName,
  company__domain as company_enrichment_website_domain,
  SPLIT(company__domainAliases,',') as company_enrichment_all_website_domains,
  SPLIT(company__site__phoneNumbers___,',') as company_enrichment_all_contact_phones,
  SPLIT(company__site__emailAddresses,',') as company_enrichment_all_contact_emails,
  company__category__sector as company_enrichment_industry_sector,
  company__category__industryGroup as company_enrichment_industry_group,
  company__category__industry as company_enrichment_industry,
  company__category__subIndustry as company_enrichment_sub_industry,
  company__category__sicCode as company_enrichment_SIC_code,
  company__category__naicsCode as company_enrichment_NAICS_code,
  SPLIT(company__tags___,',') as company_enrichment_all_tags,
  company__description as company_enrichment_description,
  company__foundedYear as company_enrichment_founded_year,
  company__location as company_enrichment_location,
  company__timeZone as company_enrichment_time_zone,
  company__utcOffset as company_enrichment_utc_offset,
  company__geo__streetNumber as company_enrichment_street_number,
  company__geo__streetName as company_enrichment_street_name,
  company__geo__subPremise as company_enrichment_sub_premise,
  company__geo__city as company_enrichment_city,
  company__geo__postalCode as company_enrichment_postal_code,
  company__geo__state as company_enrichment_state,
  company__geo__stateCode as company_enrichment_state_code,
  company__geo__country as company_enrichment_country,
  company__geo__countryCode as company_enrichment_country_code,
  company__geo__lat as company_enrichment_geo_lat,
  company__geo__lng as company_enrichment_geo_long,
  company__logo as company_enrichment_logo_url,
  company__facebook__handle as company_enrichment_facebook_user_name,
  company__facebook__likes as company_enrichment_facebook_total_likes,
  company__linkedin__handle as company_enrichment_linkedin_user_name,
  company__twitter__handle as company_enrichment_twitter_user_name,
  company__twitter__id as company_enrichment_twitter_id,
  company__twitter__bio as company_enrichment_twitter_bio,
  company__twitter__followers as company_enrichment_twitter_followers,
  company__twitter__following as company_enrichment_twitter_following,
  company__twitter__location as company_enrichment_twitter_location,
  company__twitter__site as company_enrichment_twitter_website_url,
  company__crunchbase__handle as company_enrichment_crunchbase_user_name,
  company__emailProvider as company_enrichment_is_email_provider,
  company__type as company_enrichment_company_type,
  company__ticker as company_enrichment_company_stock_ticker,
  company__identifiers__usEIN as company_enrichment_usEIN,
  company__phone as company_enrichment_phone,
  company__metrics__alexaUsRank as company_enrichment_alexaUsRank,
  company__metrics__alexaGlobalRank as company_enrichment_alexaGlobalRank,
  company__metrics__employees as company_enrichment_total_employees,
  company__metrics__employeesRange as company_enrichment_employeesRang,
  company__metrics__marketCap as company_enrichment_market_capitalisation,
  company__metrics__raised as company_enrichment_total_funding_raised,
  company__metrics__annualRevenue as company_enrichment_total_annual_revenue,
  company__metrics__estimatedAnnualRevenue as company_enrichment_estimated_annual_revenue,
  company__metrics__fiscalYearEnd as company_enrichment_fiscal_year_end,
  SPLIT(company__tech,',') as company_enrichment_all_technologies,
  SPLIT(company__techCategories) as company_enrichment_all_technology_categories,
  company__parent__domain as company_enrichment_parent_website_domain,
  company__ultimateParent__domain as company_enrichment_ultimate_parent_website_domain,
  company__indexedAt as company_enrichment_last_modified_at
FROM
  source)
SELECT *
FROM renamed
