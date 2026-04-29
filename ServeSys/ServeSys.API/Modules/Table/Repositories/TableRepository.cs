using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using ServeSys.API.Modules.Table.Data;
using ServeSys.API.Modules.Table.Entities;
using ServeSys.API.Modules.Table.Interfaces.Repositories;
using System.Linq.Expressions;

namespace ServeSys.API.Modules.Table.Repositories
{
    public class TableRepository : ITableRepository
    {
        private readonly TableDbContext _context;
        public TableRepository(TableDbContext context)
        {
            _context = context;
        }

        public async Task<bool> UpdateAsync(
        Expression<Func<DiningTable, bool>> predicate,
        Expression<Func<SetPropertyCalls<DiningTable>, SetPropertyCalls<DiningTable>>> setPropertyCalls,
        CancellationToken cancellationToken = default)
        {
            var affected = await _context.DiningTables
                .Where(predicate)
                .ExecuteUpdateAsync(setPropertyCalls, cancellationToken);

            return affected > 0;
        }

        public async Task<IEnumerable<DiningTable>> FindAsync(Expression<Func<DiningTable, bool>>? predicate,
            CancellationToken cancellationToken)
        {
            if(predicate == null)
            {
                predicate = t => true;
            }
            var tables = await _context.DiningTables.Where(predicate).ToListAsync(cancellationToken);
            return tables;
        }
    }
}
