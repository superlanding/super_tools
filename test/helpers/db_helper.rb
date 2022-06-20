module DbHelper

  def init_db
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: "db/test.sqlite3"
    )
  end

  def clear_db
    ActiveRecord::Tasks::DatabaseTasks.purge_all
  end
end
