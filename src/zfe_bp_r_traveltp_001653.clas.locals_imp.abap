CLASS LHC_TRAVEL DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Travel
        RESULT result,
      CALCULATETRAVELID FOR DETERMINE ON SAVE
        IMPORTING
          KEYS FOR  Travel~CalculateTravelID ,
      reCalcTotalPrice FOR MODIFY
            IMPORTING keys FOR ACTION Travel~reCalcTotalPrice,
      calculateTotalPrice FOR DETERMINE ON MODIFY
            IMPORTING keys FOR Travel~calculateTotalPrice.
ENDCLASS.

CLASS LHC_TRAVEL IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD CALCULATETRAVELID.
  READ ENTITIES OF ZI_FE_TRAVEL_001653 IN LOCAL MODE
    ENTITY Travel
      ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(entities).
  DELETE entities WHERE TravelID IS NOT INITIAL.
  Check entities is not initial.
  "Dummy logic to determine object_id
  SELECT MAX( TRAVEL_ID ) FROM ZFE_ATRAV_001653 INTO @DATA(max_object_id).
  "Add support for draft if used in modify
  "SELECT SINGLE FROM FROM ZFE_DTRAV_001653 FIELDS MAX( TravelID ) INTO @DATA(max_orderid_draft). "draft table
  "if max_orderid_draft > max_object_id
  " max_object_id = max_orderid_draft.
  "ENDIF.
  MODIFY ENTITIES OF ZI_FE_TRAVEL_001653 IN LOCAL MODE
    ENTITY Travel
      UPDATE FIELDS ( TravelID )
        WITH VALUE #( FOR entity IN entities INDEX INTO i (
        %tky          = entity-%tky
        TravelID     = max_object_id + i
  ) ).
  ENDMETHOD.

  METHOD reCalcTotalPrice.

    TYPES: BEGIN OF ty_amount_per_currencycode,
            amount        TYPE /dmo/total_price,
            currency_code TYPE /dmo/currency_code,
    END OF ty_amount_per_currencycode.

    DATA: amount_per_currencycode TYPE STANDARD TABLE OF ty_amount_per_currencycode.

    " Read all relevant travel instances.
    READ ENTITIES OF ZI_FE_Travel_001653 IN LOCAL MODE
        ENTITY Travel
            FIELDS ( BookingFee CurrencyCode )
            WITH CORRESPONDING #( keys )
        RESULT DATA(travels).

    DELETE travels WHERE CurrencyCode IS INITIAL.

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
    " Set the start for the calculation by adding the booking fee.
    amount_per_currencycode = VALUE #( ( amount        = <travel>-BookingFee
                                        currency_code = <travel>-CurrencyCode ) ).

    " Read all associated bookings and add them to the total price.
    READ ENTITIES OF ZI_FE_Travel_001653 IN LOCAL MODE
        ENTITY Travel BY \_Booking
        FIELDS ( FlightPrice CurrencyCode )
        WITH VALUE #( ( %tky = <travel>-%tky ) )
        RESULT DATA(bookings).

    LOOP AT bookings INTO DATA(booking) WHERE CurrencyCode IS NOT INITIAL.
    COLLECT VALUE ty_amount_per_currencycode( amount        = booking-FlightPrice
            currency_code = booking-CurrencyCode ) INTO amount_per_currencycode.
    ENDLOOP.


    CLEAR <travel>-TotalPrice.
    LOOP AT amount_per_currencycode INTO DATA(single_amount_per_currencycode).
    " If needed do a Currency Conversion
    IF single_amount_per_currencycode-currency_code = <travel>-CurrencyCode.
        <travel>-TotalPrice += single_amount_per_currencycode-amount.
    ELSE.
        /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
            iv_amount                   =  single_amount_per_currencycode-amount
            iv_currency_code_source     =  single_amount_per_currencycode-currency_code
            iv_currency_code_target     =  <travel>-CurrencyCode
            iv_exchange_rate_date       =  cl_abap_context_info=>get_system_date( )
        IMPORTING
            ev_amount                   = DATA(total_booking_price_per_curr)
        ).
        <travel>-TotalPrice += total_booking_price_per_curr.
    ENDIF.
    ENDLOOP.
    ENDLOOP.

    " write back the modified total_price of travels
    MODIFY ENTITIES OF ZI_FE_Travel_001653 IN LOCAL MODE
    ENTITY travel
        UPDATE FIELDS ( TotalPrice )
        WITH CORRESPONDING #( travels ).

  ENDMETHOD.


  METHOD calculateTotalPrice.
     MODIFY ENTITIES OF ZI_FE_Travel_001653 IN LOCAL MODE
        ENTITY Travel
        EXECUTE reCalcTotalPrice
        FROM CORRESPONDING #( keys ).
  ENDMETHOD.

ENDCLASS.
