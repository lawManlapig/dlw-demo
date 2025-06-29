@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Conversion CDS - Item(Projection)'
@Metadata:{
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
define view entity ZDLW_C_Conversion_Item
  as projection on ZDLW_I_Conversion_Item
{
  key ConvId,
  key ConvSubId,
      ValueFrom,
      DescriptionFrom,
      ValueTo,
      DescriptionTo,

      /* Associations */
      _Header: redirected to parent ZDLW_C_Conversion_Header
}
