import 'package:application/events/domain_event_notification.dart';
import 'package:cqrs_mediator/cqrs_mediator.dart';
import 'package:domain/events/cart_closed_event.dart';
import 'package:domain/events/domain_event.dart';

class DomainEventService {
  Future<void> call(DomainEvent event) async {
    var notification = createNotification(event);
    if (notification == null) return;
    if (Mediator.instance.getHandlersFor(notification).isEmpty) return;
    await Future.wait(Mediator.instance.runAll(notification));
  }

  Future<void> callAll(List<DomainEvent> domainEvents) async {
    for (var event in domainEvents) {
      await call(event);
    }
  }

  DomainEventNotification? createNotification(DomainEvent event) {
    if (event is CartClosedEvent) {
      return DomainEventNotification<CartClosedEvent>(event);
    }

    return null;
  }
}