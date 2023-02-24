# add a boolean dimension to allow aggregation using the status dimension

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: order_is_canceled {
    description: "A value equal to Yes measn that the order has a canceled status. A value equal to No means that the order does not have a canceled status."
    type: yesno
    sql: ${status} = "Cancelled" ;;
  }


# utilizing the new boolean dimension to create measures

  measure: total_revenue_from_canceled_orders {
    label: "Total Revenue Lost From Canceled Orders"
    description: "Sum of sale price for orders with canceled status."
    type: sum
    sql: ${sale_price} ;;
    filters: [order_is_canceled: "Yes"]
    value_format_name: usd
  }
  
  measure: percent_revenue_canceled_orders {
    label: "% Revenue Lost From Canceled Orders"
    description: "Total revenue lost from canceled orders as a percentage of the total revenue from all orders."
    type: number
    value_format_name: percent_2
    sql: 1.0*${total_revenue_from_canceled_orders} /NULLIF(${total_revenue}, 0) ;;
  }
  
  
# hiding fields from an entire explore
  
  explore: events {
  fields: [ALL_FIELDS*, -users.city, -users.email, -users.first_name,-users.gender, -users.last_name, -users.state]
  join: event_session_facts {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
    relationship: many_to_one
  }
  
  
# hiding fields from a view
  
  dimension: latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.longitude ;;
  }
  
  
# grouping fields by category for ease of navigation
  
  dimension: city {
    group_label: "Location"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "Location"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

# adding grouping to explores

explore: events {
  group_label: "E-commerce - Marketing Team"

explore: order_items {
  group_label: "E-commerce - Inventory Team"
