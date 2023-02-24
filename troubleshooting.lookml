# basic view file of SQL derived table

view: user_order_lifetime {
  derived_table: {
    sql: SELECT
        order_items.user_id as user_id
          ,COUNT(*) as lifetime_orders
          ,SUM(order_items.sale_price) as lifetime_sales
      FROM cloud-training-demos.looker_ecomm.order_items
      GROUP BY user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_sales {
    type: number
    sql: ${TABLE}.lifetime_sales ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders, lifetime_sales]
  }
}


# sample of the updated training_ecommerce.model file to join the view to the events explore

explore: events {
  join: user_order_lifetime {
    type: left_outer
    sql_on: ${events.user_id} = ${user_order_lifetime.user_id} ;;
    relationship: many_to_one
  }
  
 #  adding a dimension for average sales to the users.view
  dimension: average_order_price {
    type: number
    sql_on: ${user_order_lifetime.lifetime_sales} / ${user_order_lifetime.lifetime_orders} ;;
    value_format_name: usd
  }

# note - you have to joint he user_order_lifetime.view to the order_items explore

explore: order_items {
  join: user_order_lifetime {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_order_lifetime.user_id} ;;
    relationship: many_to_one
  }
