CREATE TABLE test1 (a int, b text);


CREATE PROCEDURE transaction_test1()
LANGUAGE plr
AS $$
  version_11plus  <- pg.spi.exec("select current_setting('server_version_num')::integer >= 110000;")
  if(version_11plus[[1]])
  {
    for(i in 0:9)
    {
      pg.spi.exec(paste("INSERT INTO test1 (a) VALUES (", i, ")"))
      if (i %% 2 == 0) 
      {
        pg.spi.commit()
      } 
      else 
      {
        pg.spi.rollback()
      }
    }
  }
  else
  {
    pg.spi.exec("INSERT INTO test1 (a) VALUES (0);")
    pg.spi.exec("INSERT INTO test1 (a) VALUES (2);")
    pg.spi.exec("INSERT INTO test1 (a) VALUES (4);")
    pg.spi.exec("INSERT INTO test1 (a) VALUES (8);")
  }
$$;

CALL transaction_test1();

SELECT * FROM test1;


TRUNCATE test1;
