# create an extend to hide PII from users.view

include: "users.view"

view: user_pii_challenge_hdyx {
  extends: [users]
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }
  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }
  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }
}


# include the extend in the default users.view
include: "<name of extend>.view"

# be sure to use the "hidden: yes" parameter to hide the views from users.view and only show them in the extended view
