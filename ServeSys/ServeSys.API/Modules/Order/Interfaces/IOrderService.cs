using ServeSys.API.Modules.Order.DTOs;

namespace ServeSys.API.Modules.Order.Interfaces
{
    public interface IOrderService
    {
       Task<OrderResponse> PlaceOrderAsync(OrderDto orderDto, CancellationToken cancellationToken = default);
    }
}
