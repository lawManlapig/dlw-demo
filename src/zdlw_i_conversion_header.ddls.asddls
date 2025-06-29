@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Conversion CDS - Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZDLW_I_Conversion_Header
  as select from zdlw_conv_hdr
  composition [0..*] of ZDLW_I_Conversion_Item as _Item
{
  key conv_id         as ConvId,
      description     as Description,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      /* Exposed Association */
      _Item // Make association public
}
