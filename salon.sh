#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
MAIN_MENU()
{
  #greeting
  echo 'Hello, how can i help you today ?'
  #display service menu
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while IFS="|" read SERVICE_ID NAME
  do
  echo "$SERVICE_ID) $NAME"
  done
  #prompt users to input a service id
  echo -e "\nPlease choose a service"
  #input a service id
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ [1-3] ]]
  then
    MAIN_MENU
  else
    #continue algorithm here
    echo -e "\nYou have chosen a --- service "
    echo "Please enter your phone"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    # if customer doesnt exist
    if [[ -z $CUSTOMER_NAME ]] 
    then
      # input name
      echo -e "\nPlease enter your name."
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      # echo $INSERT_CUSTOMER_RESULT
    fi
      # input time
      echo -e "\nPlease enter a time for your visit."
      read SERVICE_TIME
      # get customer id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME' ")
      # insert an appointment
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU
