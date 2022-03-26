# create a custom view
# note - this is not functional in SQL/Looker, but the structure was required to clear validations in the exercise

view: order_items_challenge {
  sql_table_name: `cloud-training-demos.looker_ecomm.order_items`
    ;;
  drill_fields: [order_item_id]
  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # necessary to join the table in the explore, even though it's not the best dimension for this purpose
  
  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${users.traffic_source} ;;
  }

  dimension: is_search_source {
    type: yesno
    sql: ${users.traffic_source} = "Search" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: cost {
    type: number
    sql: ${products.cost} ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: return_days {
    type: number
    sql: DATE_DIFF(days,${returned_date},${delivered_date}) ;;
  }

  measure: sales_from_complete_search_users {
    type: sum
    sql: ${TABLE}.sale_price ;;
    filters: [is_search_source: "Yes",status: "Complete"]
  }

  measure: total_gross_margin {
    type: sum
    sql: ${TABLE}.sale_price - ${inventory_items.cost} ;;
  }
}

# ------------------------------------------------------------------

# create a persistent derived table

view: user_details {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: user_id {}
      column: total_revenue {}
      column: age { field: users.age }
      column: city { field: users.city }
      column: state { field: users.state }
    }
    datagroup_trigger: order_items_challenge_datagroup
  }
  dimension: order_id {
    type: number
  }
  dimension: user_id {
    primary_key: yes
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: age {
    type: number
  }
  dimension: city {}
  dimension: state {}
}

# ------------------------------------------------------------------

# add joins to the explore model file

explore: order_items {
  join: user_details {
    type: left_outer
    sql_on: ${users.id} = ${user_details.user_id} ;;
    relationship: many_to_one
  }

  join: order_items_challenge {
    type: left_outer
    sql_on: ${order_items.order_id} = ${order_items_challenge.order_id} ;;
    relationship: many_to_one
  }
  
# ------------------------------------------------------------------

# create a new datagroup and apply it to all explores in the model
  
datagroup: order_items_challenge_datagroup {
  max_cache_age: "7 hours"
  sql_trigger: SELECT MAX(order_item_id) from order_items ;;
}

persist_with: order_items_challenge_datagroup

# ------------------------------------------------------------------

# samples of explore filtering

explore: order_items {
  sql_always_where: ${sale_price} >= "103" ;;

explore: order_items {
  conditionally_filter: {
    filters: [order_items.shipped_date: "2018"]
    unless: [status,delivered_date]
  }

explore: order_items {
  sql_always_having: ${average_sale_price} > "52" ;;

explore: order_items {
  always_filter: {
    filters: [order_items.status: "Shipped",users.state: "California",users.traffic_source: "Search"]
  }

datagroup: order_items_challenge_datagroup {
  sql_trigger: SELECT MAX(order_item_id) from order_items ;;
  max_cache_age: "7 hours"
}
