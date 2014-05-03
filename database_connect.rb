require 'pg'

module DatabaseConnect

  DATABASE_NAME = 'mta_status_updates'

  def database_initializer
    ignore_errors = "/dev/null 2>&1"
    `createdb #{DATABASE_NAME} #{ignore_errors}`
  end

  def database_connection
    PG.connect(dbname: DATABASE_NAME)
  end

end

