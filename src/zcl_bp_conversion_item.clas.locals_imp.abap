CLASS lhc_convserionitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR ConvserionItem~validateMandatoryFields.

ENDCLASS.

CLASS lhc_convserionitem IMPLEMENTATION.

  METHOD validateMandatoryFields.
    READ ENTITIES OF ZDLW_I_Conversion_Header
    IN LOCAL MODE
    ENTITY ConvserionItem
    FIELDS ( ValueFrom ValueTo )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_read_result).

    LOOP AT lt_read_result ASSIGNING FIELD-SYMBOL(<lfs_read>).
      IF <lfs_read>-ValueFrom IS INITIAL.
        " Error Message
        APPEND VALUE #(
            %tky = <lfs_read>-%tky
        ) TO failed-convserionitem.

        APPEND VALUE #(
            %tky = <lfs_read>-%tky
            %msg = me->new_message(
                     id       = 'ZDLW_CUSTOM_MESSAGES'
                     number   = '001'
                     severity =  if_abap_behv_message=>severity-error
                   )
            %element-ValueFrom = if_abap_behv=>mk-on
        ) TO reported-convserionitem.
      ENDIF.

      IF <lfs_read>-ValueTo IS INITIAL.
        " Error Message
        APPEND VALUE #(
            %tky = <lfs_read>-%tky
        ) TO failed-convserionitem.

        APPEND VALUE #(
            %tky = <lfs_read>-%tky
            %msg = me->new_message(
                     id       = 'ZDLW_CUSTOM_MESSAGES'
                     number   = '002'
                     severity =  if_abap_behv_message=>severity-error
                   )
            %element-ValueTo = if_abap_behv=>mk-on
        ) TO reported-convserionitem.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
