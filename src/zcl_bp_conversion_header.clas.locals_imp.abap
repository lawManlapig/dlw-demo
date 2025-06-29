CLASS lhc_ConversionHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ConversionHeader RESULT result.
    METHODS earlynumbering_cba_item FOR NUMBERING
      IMPORTING entities FOR CREATE conversionheader\_item.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE conversionheader.

ENDCLASS.

CLASS lhc_ConversionHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  " Early Numbering Logic
  METHOD earlynumbering_create.
    DATA: lv_current_number TYPE i.
    DATA(lt_entities) = entities.

    " Make sure Conversion ID is initial
    DELETE lt_entities WHERE ConvId IS NOT INITIAL.

    IF lt_entities[] IS NOT INITIAL.

      " Note ni Law: Wala akong auth para gumawa ng NR
      " sa customizing HAHA. gumawa na lang ako ng
      " logic for number generation...
      " Pero maganda dito, gumawa kayo ng number range
      " object.. :)

*      TRY.
*          " Generate from number range
*          cl_numberrange_runtime=>number_get(
*            EXPORTING
*              nr_range_nr       = '01'
*              object            = 'ZDLW_NMBR'
*              quantity          = CONV #(  lines( lt_entities ) )
*            IMPORTING
*              number            = DATA(lv_latest_number)
*              returncode        = DATA(lv_return_code)
*              returned_quantity = DATA(lv_quantity)
*          ).
*        CATCH cx_nr_object_not_found.
*        CATCH cx_number_ranges INTO DATA(lo_error).
*          LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<lfs_entities>).
*            " Error handling
*            " Failed Export
*            APPEND VALUE #(
*                %cid = <lfs_entities>-%cid
*                %key = <lfs_entities>-%key
*            ) TO failed-conversionheader.
*
*            " Reported Export
*            APPEND VALUE #(
*                %cid = <lfs_entities>-%cid
*                %key = <lfs_entities>-%key
*                %msg = lo_error
*            ) TO reported-conversionheader.
*          ENDLOOP.
*
*          " Stop processing further
*          EXIT.
*      ENDTRY.

      SELECT FROM zdlw_conv_hdr
      FIELDS conv_id
      ORDER BY conv_id DESCENDING
      INTO TABLE @DATA(lt_conversion_header).

      IF sy-subrc IS INITIAL.
        DATA(lv_latest_number) = lt_conversion_header[ 1 ]-conv_id.
        lv_current_number = lv_latest_number.
      ENDIF.

*      " Make sure quantity and entities are equal
*      ASSERT lv_quantity = lines( lt_entities ).

      " Get latest number
      " This is to make sure that there are no gaps in
      " the auto-generated number ID
*      lv_current_number = lv_latest_number - lv_quantity.

      " Fill Mapped Table
      LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<lfs_entities>).
        lv_current_number += 1.

        APPEND VALUE #(
           %cid = <lfs_entities>-%cid
           convid = lv_current_number
        ) TO mapped-conversionheader.
      ENDLOOP.
    ENDIF. " --> IF lt_entities[] IS NOT INITIAL...
  ENDMETHOD.

  METHOD earlynumbering_cba_Item.
    DATA: lv_latest_item TYPE zdlw_conv_hdr-conv_id.

    " Get details from Main Entity
    READ ENTITIES OF ZDLW_I_Conversion_Header
    IN LOCAL MODE
    ENTITY ConversionHeader
    BY \_Item
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_read_result).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities>)
    GROUP BY <lfs_entities>-ConvId.

      " Get latest Item
      lv_latest_item = REDUCE #(
          INIT lv_total = CONV zdlw_conv_itm-conv_sub_id( '0' )
          FOR ls_read_result IN lt_read_result
          USING KEY entity
          WHERE ( source-%tky = <lfs_entities>-%tky )
          NEXT lv_total = COND zdlw_conv_itm-conv_sub_id(
              WHEN lv_total < ls_read_result-target-ConvSubId
              THEN ls_read_result-target-ConvSubId
              ELSE lv_total ) ).

      " Generate the number ID
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities_draft>)
      USING KEY entity WHERE ConvId = <lfs_entities>-ConvId.
        LOOP AT <lfs_entities>-%target ASSIGNING FIELD-SYMBOL(<lfs_item_details>).
          APPEND CORRESPONDING #( <lfs_item_details> ) TO mapped-convserionitem
          ASSIGNING FIELD-SYMBOL(<lfs_item_new>).
          IF <lfs_item_new>-ConvSubId IS INITIAL.
            lv_latest_item += 10. " Intervals
            <lfs_item_new>-ConvSubId = lv_latest_item.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
