CLASS lhc_ConversionHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ConversionHeader RESULT result.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE conversionheader.

ENDCLASS.

CLASS lhc_ConversionHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  " Early Numbering Logic
  METHOD earlynumbering_create.
    DATA: lv_current_number TYPE i.

  ENDMETHOD.

ENDCLASS.
