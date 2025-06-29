@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Conversion CDS - Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDLW_I_Conversion_Item
  as select from zdlw_conv_itm
  association to parent ZDLW_I_Conversion_Header as _Header on $projection.ConvId = _Header.ConvId
{
  key conv_id          as ConvId,
  key conv_sub_id      as ConvSubId,
      value_from       as ValueFrom,
      description_from as DescriptionFrom,
      value_to         as ValueTo,
      description_to   as DescriptionTo,

      /* Exposed Association */
      _Header
}
