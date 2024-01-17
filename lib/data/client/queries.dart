class Queries {
  Queries._();

  //app config provider

  static String getAppConfig = """
query GetAppConfig {
    getAppConfig(appModule: "customer") {
        androidVersion
        androidAppPath
        androidMMode
        iosVersion
        iosAppPath
        iosMMode
        appModule
        iosMMode
        androidMMode
    }
}
  """
      .replaceAll('\n', '');

  // auth provider
  static String getUser = """
query GetUser {
    me {
        id
        name
        email
        phone
        zpointsDescription
        analytics {
            openBookings
            rewardPointBalance
            totalBookings
            pendingPaymentsCounts
        }
       customerDetails {
            favoriteServices {
                id
                name
                icon {
                    url
                }
            }
        }
    }
}
  """
      .replaceAll('\n', '');

  static String getHome = '''
query getCombinedHome {
  getCombinedHome {
    getAreas {
      id
      name
      code
      pinCodes {
        id
        areaId
        pinCode
      }
    }
    getServiceCategories {
      id
      name
      code
      images {
        url
        id
      }
      services {
        id
        code
        icon {
          url
          thumbnail {
            url
          }
        }
        addons {
          id
          name
          description
          type
          unit
          unitPrice {
            commission
            commissionTax
            partnerTax
            partnerPrice
            total
            totalTax
          }
          minUnit
          maxUnit
          serviceId
        }
        name
        billingOptions {
          id
          code
          description
          name
          recurring
          recurringPeriod
          autoAssignPartner
          maxUnit
          minUnit
          unit
          unitPrice {
            commission
            partnerPrice
            commissionTax
            partnerTax
            total
            totalTax
          }
          additionalUnitPrice {
            partnerTax
            partnerPrice
            commission
            commissionTax
            total
            totalTax
          }
          serviceAdditionalPayments {
            id
            price {
              commission
              partnerPrice
              commissionTax
              partnerTax
              total
              totalTax
            }
            name
            description
            mandatory
            refundable
            serviceBillingOptionId
          }
        }
        requirements {
          id
          description
          title
        }
        inputs {
          id
          name
          description
          key
          type
        }
        medias {
          url
          thumbnail {
            id
            url
          }
        }
        icon {
          id
          url
          name
        }
      }
    }
    getPopularServices {
      id
      name
      medias {
        type
        thumbnail {
          name
        }
        id
        url
        enabled
      }
      thumbnail {
                url
            }
     
    }
    getLoyaltyPointRates {
      pointValue
      maxPointEarnedPerBooking
      maxPointRedeemedPerBooking
      maxPointEarnedPerReferral
    }
    getBanners {
      id
      title
      description
      url
      mediaId
      media {
        id
        url
      }
    }
 
   getHomeContent {
            id
            status
            image
            description
        }
    getHomeServices {
      id
      name
      medias {
        type
        name
        url
        thumbnail {
          name
        }
        id
      }
      icon {
        id
        url
        name
      }
      inputs {
        id
        name
        description
        key
        type
      }
      requirements {
        description
        id
        title
      }
      billingOptions {
        id
        code
        name
        description
        recurring
        recurringPeriod
        autoAssignPartner
        unitPrice{
          commission
          partnerPrice            
          commissionTax
          partnerTax
          total
          totalTax
        }
        unit
        minUnit
        maxUnit
        serviceAdditionalPayments {
          price{
            commission
            partnerPrice            
            commissionTax
            partnerTax
            total
            totalTax
          }
          id
          name
          mandatory
          description
          refundable
          serviceBillingOptionId
        }
      }
      code     
      description
    }
  }
}
  '''
      .replaceAll('\n', '');

  static String getCities = '''
 query GetCities {
    getCities {
        id
        name
        code
        areas {
            id
            name
            code
            pinCodes {
                id
                pinCode
                areaId
            }
        }
    }
}
  '''
      .replaceAll('\n', '');

  // Services  Provider
  static String getServiceById = '''
  query getService(\$id: String!) {
    getService (id: \$id){
      id
      name
      code
      isTeamService
      medias {
        type
        thumbnail {
          name
        }
        id
        url
        enabled
      }
      requirements {
        description
        id
        title
      }
      billingOptions {
        id
        code
        name
        description
        recurring
        recurringPeriod
        autoAssignPartner
        unitPrice {
          commission
          partnerPrice 
          unitPrice           
          commissionTax
          partnerTax
          total
          totalTax
        }
        unit
        minUnit
        maxUnit
        serviceAdditionalPayments {
          price {
            commission
            partnerPrice            
            commissionTax
            partnerTax
            total
            totalTax
          }
          id
          name
          mandatory
          description
          refundable
          serviceBillingOptionId
        }
      }
        propertyTypes {
            id
            title
            noRooms
        }
        rooms {
            id
            title
        }
        propertyAreas {
            id
            title
            hours
        }
      inputs{
        id
        name
        description
        key
        type
      }     
      description
      isFavorite
    }
  }
  '''
      .replaceAll('\n', '');

  static String getServiceCategories = '''
query GetServiceCategories {
    getServiceCategories {
        id
        name
        services {
            id
            name
            icon {
                url
            }
        }
    }
}
 '''
      .replaceAll('\n', '');

  static String searchService = '''
query GetServices(\$search:String!){
    getServices(search: \$search) {
        id
        name
        icon {
            url
        }
    }
}

 '''
      .replaceAll('\n', '');
  // schedule provider
  static String getTimeSlots = '''
query getServiceBookingSlots(\$date: DateTime!, \$billingOptionId: String!, \$partnerId: String){
  getServiceBookingSlots(
    date: \$date,
    billingOptionId: \$billingOptionId
    partnerId: \$partnerId
  ) {
    start
    end
    available
  }
}
 '''
      .replaceAll('\n', '');

  // schedule provider
  static String getCmsContent = '''
query GetCmsContent {
    getCmsContent {
        id
        aboutUs
        referPolicy
        termsConditionsCustomer
        privacyPolicy
        safetyPolicy
        cancellationPolicyCustomer
    }
}
 '''
      .replaceAll('\n', '');

  // checkout provider
  static String getBookingSummary = '''
query GetBookingSummary(\$serviceBillingOptionId: String!,\$units:Int!,\$couponCode:String!,\$redeemPoints:Float!) {
    getBookingSummary(
        data: {couponCode: \$couponCode, redeemPoints: \$redeemPoints, serviceBillingOptionId: \$serviceBillingOptionId, units: \$units}
    ) {
        partnerRate
        partnerDiscount
        partnerAmount
        partnerGSTPercentage
        partnerGSTAmount
        totalPartnerAmount
        subTotal
        totalDiscount
        totalAmount
        totalGSTAmount
        grandTotal
        totalRefundable
        totalRefunded
        cancellationPolicyCustomer
        isCouponApplied
   coupons {
            id
            code
            description
            name
            terms
            canApply
            couponApplied
            minOrder
        }
        isZpointsApplied
        couponEntered
        zpointsEntered
        redeemError
        message
        appliedZpoints
        zpointsBalance
        totalRefunded
        appliedCoupon
        maxReedeemablePoints
    }
}

 '''
      .replaceAll('\n', '');

  //bookings providers
  static String getUserBookings = '''
query getUserBookingServiceItems(\$pageNumber:Int,\$pageSize:Int,\$status: UserBookingsStatusTypeEnum ) {
  getUserBookingServiceItems (pagination:{pageNumber:\$pageNumber,pageSize:\$pageSize},filter:{status:\$status}) {
    data {
      id
      bookingServiceItemStatus
      bookingService {
        service {
          name
          icon {
            url
          }
        }
        serviceBillingOptionId
        booking {
          userBookingNumber
        }
        unit
      }
      startDateTime
      endDateTime
    }
            pageInfo {
            hasNextPage
            currentPage
            currentCount
            nextPage
            totalPage
            totalCount
        }
  }
}
 '''
      .replaceAll('\n', '');
  static String getSingleBookingDetails = '''
query GetBookingServiceItem(\$id:String!) {
  getBookingServiceItem (id:\$id){
        bookingService {
            service {
            id
                name
                isFavorite
            }
            booking {
                userBookingNumber
                bookingAddress {
                    addressType
                    otherText
                    buildingName
                    locality
                    landmark
                    area {
                        name
                        city {
                            name
                        }
                    }
                    postalCode
                    alternatePhoneNumber
                }
                bookingNote
            }
            serviceBillingOptionId
            serviceBillingOption {
                name
            }
            serviceRequirements
            otherRequirements
        }
        bookingServiceItemStatus
        amountDue
        bookingServiceItemType
        startDateTime
        endDateTime
        canReschedule
        canCancel
        canRework
        isRescheduleByPartnerPending
        isPaymentPending
        canCallPartner
        isCancelled
        canBookAgain
        canRateBooking
        id
        chargedPrice {
            totalAmount
            subTotal
            totalDiscount
            totalGSTAmount
            grandTotal
        }
        cancellationPolicyCustomer
        statusTracker {
            status_label
            status_value
        }
                additionalWorks {
                bookingAdditionalWorkStatus
            bookingAddons {
                name
                units
                amount {
                    grandTotal
                }
            }
            additionalHoursUnits
            additionalHoursAmount {
                grandTotal
            }
            totalAdditionalWorkAmount {
                grandTotal
            }
            isPaid
        }
        workCode
            cancelDetails {
        cancelAmount
        cancelTotalAmount
    }
    pendingRescheduleByPartner {
            startDateTime
            endDateTime
        }
         servicePropertyType {
            title
            noRooms
        }
        serviceRoom {
            title
        }
        servicePropertyArea {
            title
            hours
        }
    }
}

 '''
      .replaceAll('\n', '');

  // address provider
  static String fetchAddressList = '''
query {
  getCustomerAddresses {
    customerAddresses {
      id
      buildingName
      locality
      landmark
      areaId
      area {
        id
        name
      }
      postalCode
      addressType
      otherText
      isDefault
    }
  }
}
 '''
      .replaceAll('\n', '');

  static String getFaqs = '''
{
  getFaqs(appType:CUSTOMER){
    id
    question
    answer
    sortOrder
    category
  }
}
'''
      .replaceAll('\n', '');
}
