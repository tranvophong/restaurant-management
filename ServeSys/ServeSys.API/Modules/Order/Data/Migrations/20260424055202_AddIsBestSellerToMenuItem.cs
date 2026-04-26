using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ServeSys.API.Modules.Order.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddIsBestSellerToMenuItem : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsBestSeller",
                table: "MenuItems",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsBestSeller",
                table: "MenuItems");
        }
    }
}
