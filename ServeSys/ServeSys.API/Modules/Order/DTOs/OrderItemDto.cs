namespace ServeSys.API.Modules.Order.DTOs
{
    public class OrderItemDto
    {
        public int MenuItemId { get; set; }
        public int Quantity { get; set; }
        public string? Notes { get; set; }
    }
}
