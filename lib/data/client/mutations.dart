class Mutations {
  Mutations._();

  static String sendOtp = """
     mutation sendOtp(\$phoneNumber: String!){
     sendOtp (data: {phoneNumber: \$phoneNumber}) {
     status
     message    
  }
}
  """
      .replaceAll('\n', '');

  static String verifyOtp = """
mutation verifyOtp(\$phoneNumber: String!,\$otp:String!,\$deviceId:String!,\$token:String!,\$device:DeviceTypeEnum!){
  verifyOtp (data: {phoneNumber: \$phoneNumber,otp:\$otp,deviceId: \$deviceId,token: \$token,device: \$device,app: CUSTOMER
  }) {
    status
    message
    data{
      isCustomerRegistered
      token
      user{
      id
      name
      phone
      email
      }
    }    
  }
}
  """
      .replaceAll('\n', '');

  static String registerUser = """
mutation registerUser(\$data:UserRegisterGqlInput!){
  registerUser(data:\$data){
    id
    name
    phone  
    email
  }
}
  """
      .replaceAll('\n', '');

  static String updateUser = """
mutation UpdateUser(\$name:String!,\$email:String!) {
    updateUser(data: {name: \$name, email: \$email}) {
        name
        email
        phone
        id
    }
}
  """
      .replaceAll('\n', '');

  static String addCustomerSupport = '''
mutation AddCustomerSupport(\$subject:String!,\$message:String!) {
    addCustomerSupport(data: {subject: \$subject, message: \$message}) {
        id
        userId
        subject
        message
        createDateTime
    }
}
 '''
      .replaceAll('\n', '');

  static String updateFavourite = '''
mutation UpdateFavoriteService(\$serviceId:String!,\$status:Boolean!) {
    updateFavoriteService(
        serviceId: \$serviceId
        status: \$status
    )
}
 '''
      .replaceAll('\n', '');

  static String addAddress = """
mutation addAddress(\$buildingName:String!,\$locality:String!,\$landmark:String!,\$areaId:String!,\$postalCode:String!,\$addressType:EnumAddressType!,\$otherText:String,\$isDefault:Boolean,
){
  addCustomerAddress(
    data: {
      buildingName: \$buildingName,
      locality: \$locality,
      landmark: \$landmark,
      areaId: \$areaId,
      postalCode: \$postalCode,
      addressType:\$addressType,
      otherText: \$otherText,
      isDefault: \$isDefault,
    }
  ) {
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
  """
      .replaceAll('\n', '');

  static String updateAddress = """
mutation UpdateCustomerAddress(\$addressId:String!,\$buildingName:String!,\$locality:String!,\$landmark:String!,\$areaId:String!,\$postalCode:String!,\$addressType:EnumAddressType!,\$otherText:String,\$isDefault:Boolean,
){
  updateCustomerAddress(
  id: \$addressId,
    data: {
      buildingName: \$buildingName,
      locality: \$locality,
      landmark: \$landmark,
      areaId: \$areaId,
      postalCode: \$postalCode,
      addressType:\$addressType,
      otherText: \$otherText,
      isDefault: \$isDefault,
    }
  ) {
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
  """
      .replaceAll('\n', '');

  static String deleteAddress = """
mutation deleteAddress(\$id:String!) {
  deleteCustomerAddress(addressId: \$id) {
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
      isDefault
      otherText
    }
  }
}
  """
      .replaceAll('\n', '');

  static String addReview = """
mutation AddReview(\$type:  ReviewTypeEnum!,\$bookingServiceItemId:String!,\$rating:Float!,\$review:String) {
    addReview(
        data: {type: \$type, bookingServiceItemId: \$bookingServiceItemId, rating: \$rating, review: \$review}
    ) {
        id
        rating
        review
    }
}
  """
      .replaceAll('\n', '');


  ///booking provider
 static String rescheduleWork = """
mutation RescheduleJob(\$bookingServiceItemId:ID!,\$scheduleTime: DateTime!,\$scheduleEndDateTime: DateTime!,\$modificationReason:String) {
    rescheduleJob(
        bookingServiceItemId: \$bookingServiceItemId
        scheduleTime: \$scheduleTime
        scheduleEndDateTime: \$scheduleEndDateTime
        modificationReason: \$modificationReason
    ) {
        id
    }
}

  """
      .replaceAll('\n', '');

 static String requestRework = """
mutation ReworkJob(\$bookingServiceItemId:ID!,\$scheduleTime: DateTime!,\$scheduleEndDateTime: DateTime!,\$modificationReason:String) {
    reworkJob(
        bookingServiceItemId: \$bookingServiceItemId
        scheduleTime: \$scheduleTime
        scheduleEndDateTime: \$scheduleEndDateTime
        workNote: \$modificationReason) {
        bookingServiceItemStatus
    }
}

  """
      .replaceAll('\n', '');


 static String cancelWork = """
mutation CancelJob(\$id:String!) {
    cancelJobs (bookingServiceItemIds: \$id) {
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
    }
}

  """
      .replaceAll('\n', '');

 static String acceptOrDeclineRequest = """
mutation ApproveJob(\$id: ID!, \$status:Boolean!) {
    approveJob(
        bookingServiceItemId: \$id
        status: \$status
    ) {
        id
        startDateTime
        endDateTime
        bookingServiceItemStatus
    }
}

  """
      .replaceAll('\n', '');

 static String callServicePartner = """
mutation CallPartnerCustomer(\$id:String!) {
    callPartnerCustomer(
        bookingServiceItemId: \$id
    )
}
  """
      .replaceAll('\n', '');

 static String payPendingPayment = """
mutation CreatePendingPaymentOrder(\$id:String!) {
    createPendingPaymentOrder(
        data: { bookingServiceItemId: \$id }
    ) {
        id
        orderId
        paymentId
        amount
        amountPaid
        amountDue
        currency
        status
        attempts
        invoiceNumber
        bookingId
    }
}

  """
      .replaceAll('\n', '');


  ///checkout provider
 static String createBooking = """
mutation CreateBooking(\$data: BookingGqlInput!) {
    createBooking(data: \$data) {
        id
        userBookingNumber
        bookingStatus
        bookingDate
        userId
        bookingNote
        appliedCoupons
        createDateTime
        bookingAmount {
            grandTotal
        }
        bookingPayments {
            id 
            orderId
           }
        bookingService {
            service {
                name
            }
            bookingServiceItems {
                id
                }
        }
    }
}

  """
      .replaceAll('\n', '');


 static String updatePayment = """
mutation confirmPayment(\$data:PaymentConfirmGqlInput!){
confirmPayment(data:\$data) {
        paymentSuccess
        booking {
            id
            userBookingNumber
            bookingStatus
            bookingService {
                unit
                service {
                    id
                    name
                    isFavorite
                }
                serviceRequirements
                bookingServiceItems {
                    workCode
                    startDateTime
                    endDateTime
                    bookingServiceItemStatus
                    bookingServiceItemType
                    id
                }
            }
            bookingAddress {
                buildingName
                postalCode
                areaId
                locality
                addressType
                landmark
                area {
                    name
                    code
                    pinCodes {
                        pinCode
                    }
                    city {
                        name
                    }
                }
                otherText
                alternatePhoneNumber
            }
            bookingAmount {
                unitPrice
                partnerRate
                partnerDiscount
                partnerAmount
                subTotal
                totalDiscount
                totalAmount
                totalGSTAmount
                grandTotal
            }
            bookingPayments {
                id
                orderId
                paymentId
                amount
                amountPaid
                amountDue
                currency
                status
                attempts
                invoiceNumber
                bookingId
            }
            bookingDate
            pendingAmount {
                amount
                pendingFor {
                    serviceItems
                    addons
                    additionPayments
                    otherPayments
                }
            }
            bookingNote
            user {
                email
                isActive
                os
                os_version
            }
        }
        zpointsEarned
        popularServices {
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
    }
}
  """
      .replaceAll('\n', '');







}
