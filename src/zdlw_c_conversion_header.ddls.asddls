@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Conversion CDS - Header(Projection)'
@Metadata:{
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
define root view entity ZDLW_C_Conversion_Header
  provider contract transactional_query
  as projection on ZDLW_I_Conversion_Header
{
      @ObjectModel.text.element: [ 'Description' ]
  key ConvId,
      Description,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      /* Associations */
      _Item : redirected to composition child ZDLW_C_Conversion_Item
}
