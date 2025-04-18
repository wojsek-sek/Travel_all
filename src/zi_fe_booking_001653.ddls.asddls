@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forBooking'
@ObjectModel.sapObjectNodeType.name: 'ZFE_Booking_001653'
define view entity ZI_FE_BOOKING_001653
  as select from ZFE_ABOOK_001653 as Booking
  association to parent ZI_FE_TRAVEL_001653 as _Travel on $projection.TravelUUID = _Travel.TravelUUID
  association [1..1] to zi_fe_conn_001653 as _Connection on $projection.CarrierID = _Connection.AirlineID and $projection.ConnectionID = _Connection.ConnectionID
  association [1..1] to zi_fe_flig_001653 as _Flight on $projection.CarrierID = _Flight.AirlineID and $projection.ConnectionID = _Flight.ConnectionID and $projection.FlightDate = _Flight.FlightDate
  association [1..1] to zi_fe_carr_001653 as _Carrier on $projection.CarrierID = _Carrier.AirlineID
  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
  association [1..1] to /DMO/I_Customer as _Customer on $projection.CustomerID = _Customer.CustomerID
{
  key BOOKING_UUID as BookingUUID,
  TRAVEL_UUID as TravelUUID,
  BOOKING_ID as BookingID,
  BOOKING_DATE as BookingDate,
  CUSTOMER_ID as CustomerID,
  CARRIER_ID as CarrierID,
  CONNECTION_ID as ConnectionID,
  FLIGHT_DATE as FlightDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  FLIGHT_PRICE as FlightPrice,
  CURRENCY_CODE as CurrencyCode,
  CREATED_BY as CreatedBy,
  LAST_CHANGED_BY as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  _Travel,
  _Connection,
  _Flight,
  _Carrier,
  _Currency,
  _Customer
  
}
