using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using ServeSys.API.Modules.Identity.Entities;

namespace ServeSys.API.Modules.Identity.Data
{
    public class IdentityModuleSeeder
    {
        public static async Task SeedAsync(IdentityDbContext dbContext)
        {
            const string adminUsername = "admin";
            var existingUser = await dbContext.Users
                .FirstOrDefaultAsync(u => u.UserName == adminUsername);

            if (existingUser != null) return;

            var user = new Entities.User
            {
                Id = "admin-id-001",
                UserName = adminUsername,
                FullName = "Admin"
            };
            user.PasswordHash = new PasswordHasher<User>()
                .HashPassword(user, "admin123");

            await dbContext.Users.AddAsync(user);
            await dbContext.SaveChangesAsync();
        }
    }
}
