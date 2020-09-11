class CreateMaterializedView < ActiveRecord::Migration[5.1]
  # -- ModelName, model_collection, alias
  # -- Event, events, e
  # -- Project, projects, p
  # -- User, users, u
  # -- DigitalAsset, digital_assets, da
  # -- TrackableMetric, trackable_metrics, tm

  # -- RefImpact, ref_impacts, ri
  # -- RefPartner, ref_partners, rp
  # -- RefCountry, ref_countries, rc

  # -- EventUser, event_users, eu
  # -- EventDigitalAsset, event_digital_assets, eda
  # -- EventProject, event_projects, ep
  # -- EventRefImpact, event_ref_impacts, eri
  # -- EventRefPartner, event_ref_partners, erp
  # -- EventRefCountry, event_ref_countries, erc  

  def up
    execute 'DROP MATERIALIZED VIEW IF EXISTS event_report;'
    execute "CREATE MATERIALIZED VIEW event_report AS
SELECT
 e.id AS event_id,
 e.description AS event_name,
 u.name AS fellow,
 ri.name AS impact_type,
 ri.genre AS impact_type_genre,
 rp.id AS ref_partner_id,
 rp.name AS partner_name,
 p.id AS project_id,
 p.name AS project_name,
 da.id AS digital_asset_id,
 da.asset AS asset,
 da.post_type,
 tm.id AS metric_id,
 tm.metric_type AS metric_type,
 tm.genre AS genre,
 tm.value AS value
from events AS e
-- Users
LEFT JOIN event_users AS eu ON eu.event_id = e.id
LEFT JOIN users AS u ON u.id = eu.user_id
-- Digital Assets
INNER JOIN event_digital_assets AS eda ON e.id = eda.event_id
INNER JOIN digital_assets AS da ON da.id = eda.digital_asset_id
-- Projects
LEFT JOIN event_projects AS ep ON ep.event_id = e.id
LEFT JOIN projects AS p ON p.id = ep.project_id
-- Ref Impacts
LEFT JOIN event_ref_impacts AS eri ON eri.event_id = e.id
LEFT JOIN ref_impacts AS ri ON ri.id = eri.ref_impact_id
-- Ref Partner
LEFT JOIN event_ref_partners AS erp ON erp.event_id = e.id
LEFT JOIN ref_partners AS rp ON rp.id = erp.ref_partner_id
-- Ref Country
LEFT JOIN event_ref_countries AS erc ON erc.event_id = e.id
LEFT JOIN ref_countries AS rc ON rc.id = erc.ref_country_id
-- Trackable Metrics
LEFT JOIN trackable_metrics AS tm ON tm.digital_asset_id = da.id;"

  end
  def down
    execute 'DROP MATERIALIZED VIEW IF EXISTS event_report;'
  end

end
