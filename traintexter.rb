    #TABLE USERS_TIMES:
    #---------------------------------------
    @db_connection.exec(<<-SQL
      create table users_notification_times
      (
        user_notification_time_id serial primary key,
        user_id                   int,
        notification_time_id      int
      );
      SQL
    )

    6.times do
      user_id = (1..4).to_a.sample
      time_id = (1..6).to_a.sample
      @db_connection.exec(<<-SQL
        insert into users_notification_times (user_id, time_id)
        values ('#{user_id}', '#{time_id}' );
        SQL
      )
    end

    results = @db_connection.exec(<<-SQL
      select * from users_notification_times ;
      SQL
      )
    p results.values


    #TABLE USERS_TRAINS:
    #---------------------------------------
    @db_connection.exec(<<-SQL
      create table users_trains
      (
        user_train_id  serial primary key,
        user_id   int,
        train_id  int
      );
      SQL
    )


    7.times do
      user_id = (1..4).to_a.sample
      train_id = (1..10).to_a.sample
      @db_connection.exec(<<-SQL
        insert into users_trains(user_id, train_id)
        values ('#{user_id}', '#{train_id}' );
        SQL
      )
    end

    results = @db_connection.exec(<<-SQL
      select * from users_trains ;
      SQL
      )
    p results.values


  end

  def test_db_query
    names_with_time = @db_connection.exec(<<-SQL
      SELECT phone,trains.name FROM users
      JOIN users_times ON users.user_id=users_times.user_id
      JOIN times ON times.time_id=users_times.time_id
      JOIN users_trains ON users.user_id=users_trains.user_id
      JOIN trains ON trains.train_id=users_trains.train_id
      WHERE times.time = '08:00:00'
      SQL
    )

    names_with_time.values
  end

end

test = TextSchedule.new
p test.test_db_query
