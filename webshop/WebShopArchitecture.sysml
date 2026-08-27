package WebShopArchitecture {
    private import ScalarValues::String;

    // Minimal, local definitions to keep this example portable across SysML v2 tools.
    part def SoftwareModule {
        attribute moduleName : String;
    }

    part def HttpService :> SoftwareModule {
        attribute serviceName : String;
    }

    part def SqlDatabase {
        attribute storeName : String;
        attribute engineName : String;
    }

    part def KafkaTopic {
        attribute channelName : String;
        attribute retention : String;
        attribute partitions : String;
    }

    part def ExternalSystem {
        attribute systemName : String;
    }

    part def Storefront :> SoftwareModule {
        attribute :>> moduleName = "web-storefront";
        port checkoutApiOut;
        port catalogApiOut;
    }

    part def ApiGateway :> HttpService {
        attribute :>> serviceName = "edge-gateway";
        port publicCheckoutIn;
        port publicCatalogIn;
        port checkoutApiOut;
        port catalogApiOut;
    }

    part def CatalogService :> HttpService {
        attribute :>> serviceName = "catalog-service";
        port apiIn;
        port catalogDbOut;
    }

    part def CheckoutService :> HttpService {
        attribute :>> serviceName = "checkout-service";
        port apiIn;
        port ordersDbOut;
        port paymentsApiOut;
        port inventoryApiOut;
        port orderEventsOut;
    }

    part def PaymentsService :> HttpService {
        attribute :>> serviceName = "payments-service";
        port apiIn;
        port paymentsDbOut;
        port providerOut;
    }

    part def InventoryService :> HttpService {
        attribute :>> serviceName = "inventory-service";
        port apiIn;
        port inventoryDbOut;
        port orderEventsIn;
        port reservationEventsOut;
    }

    part def NotificationService :> HttpService {
        attribute :>> serviceName = "notification-service";
        port orderEventsIn;
        port emailOut;
    }

    part def OrdersEventsTopic :> KafkaTopic {
        attribute :>> channelName = "commerce.orders.events.v1";
        attribute :>> retention = "7d";
        attribute :>> partitions = "8";
        port topicIngress;
        port topicEgress;
    }

    part def OrdersDatabase :> SqlDatabase {
        attribute :>> storeName = "orders-postgres";
        attribute :>> engineName = "postgres15";
        port dbIngress;
    }

    part def CatalogDatabase :> SqlDatabase {
        attribute :>> storeName = "catalog-postgres";
        attribute :>> engineName = "postgres15";
        port dbIngress;
    }

    part def PaymentsDatabase :> SqlDatabase {
        attribute :>> storeName = "payments-postgres";
        attribute :>> engineName = "postgres15";
        port dbIngress;
    }

    part def InventoryDatabase :> SqlDatabase {
        attribute :>> storeName = "inventory-postgres";
        attribute :>> engineName = "postgres15";
        port dbIngress;
    }

    part def PaymentProvider :> ExternalSystem {
        attribute :>> systemName = "stripe";
        port providerIngress;
    }

    part def EmailProvider :> ExternalSystem {
        attribute :>> systemName = "customer-email";
        port emailIngress;
    }

    part def OrderProjection :> SoftwareModule {
        attribute :>> moduleName = "order-projection";
    }

    part def WebShopSystem {
        part storefront : Storefront;
        part apiGateway : ApiGateway;
        part catalogService : CatalogService;
        part checkoutService : CheckoutService;
        part paymentsService : PaymentsService;
        part inventoryService : InventoryService;
        part notificationService : NotificationService;

        part ordersEventsTopic : OrdersEventsTopic;
        part ordersDb : OrdersDatabase;
        part catalogDb : CatalogDatabase;
        part paymentsDb : PaymentsDatabase;
        part inventoryDb : InventoryDatabase;
        part paymentProvider : PaymentProvider;
        part emailProvider : EmailProvider;

        connect storefront.checkoutApiOut to apiGateway.publicCheckoutIn;
        connect storefront.catalogApiOut to apiGateway.publicCatalogIn;

        connect apiGateway.checkoutApiOut to checkoutService.apiIn;
        connect apiGateway.catalogApiOut to catalogService.apiIn;

        connect catalogService.catalogDbOut to catalogDb.dbIngress;

        connect checkoutService.ordersDbOut to ordersDb.dbIngress;
        connect checkoutService.paymentsApiOut to paymentsService.apiIn;
        connect checkoutService.inventoryApiOut to inventoryService.apiIn;
        connect checkoutService.orderEventsOut to ordersEventsTopic.topicIngress;

        connect paymentsService.paymentsDbOut to paymentsDb.dbIngress;
        connect paymentsService.providerOut to paymentProvider.providerIngress;

        connect inventoryService.inventoryDbOut to inventoryDb.dbIngress;
        connect ordersEventsTopic.topicEgress to inventoryService.orderEventsIn;
        connect ordersEventsTopic.topicEgress to notificationService.orderEventsIn;
        connect inventoryService.reservationEventsOut to ordersEventsTopic.topicIngress;

        connect notificationService.emailOut to emailProvider.emailIngress;
    }

    // ----- Interaction scenarios ----------------------------------------------
    // Sequence scenarios use the standard SysML v2 interaction vocabulary
    // (SysML v2.0 clause 7.13 / 7.16 and 9.2.20 SequenceView):
    //   - an `occurrence def` is the scenario;
    //   - each lifeline is a `part` typed by an architecture part def, carrying
    //     `event occurrence` features ordered top-to-bottom with `then`;
    //   - each `message` connects a send event to a receive event and may be
    //     typed by a payload `item def` after `of`;
    //   - `succession first m1 then m2;` fixes the order the messages occur in.
    // `Views::checkoutFlow` and `Views::orderEventFanout` expose these as
    // SequenceViews.

    item def CheckoutRequest;
    item def CheckoutOutcome;
    item def PaymentAuthorization;
    item def PaymentResult;
    item def StockReservation;
    item def OrderCreatedEvent;
    item def ReservationEvent;
    item def NotificationRequest;
    item def OrderProjectionCommand;

    occurrence def CheckoutFlow {
        doc /*
         * Nominal (payment-approved) checkout. If payment is declined, the
         * checkout ends with a rejection to the storefront and no order-created
         * event is published; that branch is modeled in
         * WebShopBehavior::OrderLifecycleStateMachine (transition `fail_payment`).
         */

        part storefront : Storefront {
            event occurrence submitSent;
            then event occurrence outcomeReceived;
        }
        part apiGateway : ApiGateway {
            event occurrence submitReceived;
            then event occurrence forwardSent;
            then event occurrence outcomeReceived;
            then event occurrence outcomeForwarded;
        }
        part checkoutService : CheckoutService {
            event occurrence forwardReceived;
            then event occurrence authorizeSent;
            then event occurrence authorizeReturned;
            then event occurrence reserveSent;
            then event occurrence reserveReturned;
            then event occurrence orderCreatedSent;
            then event occurrence outcomeSent;
        }
        part paymentsService : PaymentsService {
            event occurrence authorizeReceived;
            then event occurrence authorizeAnswered;
        }
        part inventoryService : InventoryService {
            event occurrence reserveReceived;
            then event occurrence reserveAnswered;
        }
        part ordersEventsTopic : OrdersEventsTopic {
            event occurrence orderCreatedReceived;
        }

        message submitCheckout of CheckoutRequest
            from storefront.submitSent to apiGateway.submitReceived;
        message forwardCheckout of CheckoutRequest
            from apiGateway.forwardSent to checkoutService.forwardReceived;
        message authorizePayment of PaymentAuthorization
            from checkoutService.authorizeSent to paymentsService.authorizeReceived;
        message paymentApproved of PaymentResult
            from paymentsService.authorizeAnswered to checkoutService.authorizeReturned;
        message reserveStock of StockReservation
            from checkoutService.reserveSent to inventoryService.reserveReceived;
        message stockReserved of StockReservation
            from inventoryService.reserveAnswered to checkoutService.reserveReturned;
        message publishOrderCreated of OrderCreatedEvent
            from checkoutService.orderCreatedSent to ordersEventsTopic.orderCreatedReceived;
        message checkoutAccepted of CheckoutOutcome
            from checkoutService.outcomeSent to apiGateway.outcomeReceived;
        message checkoutOutcome of CheckoutOutcome
            from apiGateway.outcomeForwarded to storefront.outcomeReceived;

        succession first submitCheckout then forwardCheckout;
        succession first forwardCheckout then authorizePayment;
        succession first authorizePayment then paymentApproved;
        succession first paymentApproved then reserveStock;
        succession first reserveStock then stockReserved;
        succession first stockReserved then publishOrderCreated;
        succession first publishOrderCreated then checkoutAccepted;
        succession first checkoutAccepted then checkoutOutcome;
    }

    occurrence def OrderEventFanout {
        doc /* Asynchronous fan-out of the order-created event after a successful checkout. */

        part checkoutService : CheckoutService {
            event occurrence orderCreatedSent;
        }
        part ordersEventsTopic : OrdersEventsTopic {
            event occurrence orderCreatedReceived;
            then event occurrence projectionRequested;
            then event occurrence inventoryDelivered;
            then event occurrence notificationDelivered;
            then event occurrence reservationReceived;
            then event occurrence confirmationReceived;
        }
        part orderProjection : OrderProjection {
            event occurrence projectionCreated;
        }
        part inventoryService : InventoryService {
            event occurrence orderCreatedReceived;
            then event occurrence reservationPublished;
        }
        part notificationService : NotificationService {
            event occurrence orderCreatedReceived;
            then event occurrence confirmationRequested;
        }

        message publishOrderCreated of OrderCreatedEvent
            from checkoutService.orderCreatedSent to ordersEventsTopic.orderCreatedReceived;
        message createProjection of OrderProjectionCommand
            from ordersEventsTopic.projectionRequested to orderProjection.projectionCreated;
        message deliverToInventory of OrderCreatedEvent
            from ordersEventsTopic.inventoryDelivered to inventoryService.orderCreatedReceived;
        message deliverToNotifications of OrderCreatedEvent
            from ordersEventsTopic.notificationDelivered to notificationService.orderCreatedReceived;
        message inventoryReserved of ReservationEvent
            from inventoryService.reservationPublished to ordersEventsTopic.reservationReceived;
        message confirmationRequested of NotificationRequest
            from notificationService.confirmationRequested to ordersEventsTopic.confirmationReceived;

        succession first publishOrderCreated then createProjection;
        succession first createProjection then deliverToInventory;
        succession first deliverToInventory then deliverToNotifications;
        succession first deliverToNotifications then inventoryReserved;
        succession first inventoryReserved then confirmationRequested;
    }
}
