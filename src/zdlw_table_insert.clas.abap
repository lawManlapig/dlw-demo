CLASS zdlw_table_insert DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zdlw_table_insert IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA: lt_conv_header TYPE STANDARD TABLE OF zdlw_conv_hdr,
          lt_conv_item   TYPE STANDARD TABLE OF zdlw_conv_itm.

    APPEND VALUE #(
        conv_id = '00000001'
        description = 'Test Conversion'
    ) TO lt_conv_header.

    INSERT zdlw_conv_hdr FROM TABLE @lt_conv_header.

    APPEND VALUE zdlw_conv_itm(
        conv_id = '00000001'
        conv_sub_id = '00000001'
        value_from = 'Hello'
        value_to = 'Hi'
        description_from = 'Edi Hello!'
        description_to = 'Edi Hi!'
    ) TO lt_conv_item.

    APPEND VALUE zdlw_conv_itm(
        conv_id = '00000001'
        conv_sub_id = '00000002'
        value_from = 'Ay'
        value_to = 'Boom'
        description_from = 'Panot'
        description_to = 'Panes'
    ) TO lt_conv_item.

    INSERT zdlw_conv_itm FROM TABLE @lt_conv_item.
  ENDMETHOD.
ENDCLASS.
