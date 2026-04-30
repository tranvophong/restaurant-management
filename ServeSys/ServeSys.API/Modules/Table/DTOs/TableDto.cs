using ServeSys.API.Modules.Table.Entities;
using System.Text.Json.Serialization;

namespace ServeSys.API.Modules.Table.DTOs
{
    public class TableDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public int Seats { get; set; }

        [JsonConverter(typeof(JsonStringEnumConverter))]
        public TableStatus Status { get; set; }

        // Order đang phục vụ tại bàn hoặc trống thì mới có thể đặt món hoặc thanh toán
        public bool IsAvailable => Status == TableStatus.Available || Status == TableStatus.Occupied;
    }
}
