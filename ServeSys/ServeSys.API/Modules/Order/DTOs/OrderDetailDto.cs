namespace ServeSys.API.Modules.Order.DTOs
{
    public class OrderDetailDto
    {
        public string OrderCode { get; set; } = string.Empty;
        public int TableId { get; set; }
        public string Notes { get; set; } = string.Empty;
        public decimal TotalPrice { get; set; }
        public List<OrderItemDetailDto> Items { get; set; } = new List<OrderItemDetailDto>();
        public DateTime CreatedAt { get; set; }
    }
}
