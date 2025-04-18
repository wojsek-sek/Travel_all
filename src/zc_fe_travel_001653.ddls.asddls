@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forTravel'
@ObjectModel.semanticKey: [ 'TravelID' ]
@Search.searchable: true
define root view entity ZC_FE_TRAVEL_001653
  provider contract transactional_query
  as projection on ZI_FE_TRAVEL_001653 as Travel
{
  key TravelUUID,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  @EndUserText.label: 'Travel'
  @ObjectModel.text.element:  [ 'Description' ]
  TravelID,
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: '/DMO/I_Agency', 
      element: 'AgencyID'
    }
  } ]
  @EndUserText.label: 'Agency'
  @ObjectModel.text.element: [ 'AgencyName' ]
  AgencyID,
  _Agency.Name as AgencyName,
  @EndUserText.label: 'Customer'
  @ObjectModel.text.element: ['LastName']
  @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Customer', element: 'CustomerID'  } }]
  CustomerID,
  _Customer.LastName as LastName,
  BeginDate,
  EndDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  BookingFee,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  TotalPrice,
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Currency', 
      element: 'Currency'
    }
  } ]
  CurrencyCode,
  Description,
  @EndUserText.label: 'Status'
  @Consumption.valueHelpDefinition: [{ entity : { name: 'ZI_FE_STAT_001653', element: 'TravelStatusId'}  }]
  @ObjectModel.text.element: [ 'TravelStatusText' ]
  OverallStatus,
  _TravelStatus.TravelStatusText as TravelStatusText,
  OverallStatusCriticality,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  @EndUserText.label: 'Last Changed At'
  LastChangedAt,
  LocalLastChangedAt,
  _Booking : redirected to composition child ZC_FE_BOOKING_001653,
  _Agency,
  _Currency,
  _Customer,
  _TravelStatus
  
}
