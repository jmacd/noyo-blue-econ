import {DuckDBClient} from '@cmudig/duckdb'

noyodb = DuckDBClient.of({
  fieldstation: FileAttachment("noyo-fieldstation.csv")
})

topsal = noyodb.query("select Timestamp, Value from new_tbl as T where \"Series Name\" = 'Surface Salinity'");

process.stdout.write(csvFormat(topsal));
