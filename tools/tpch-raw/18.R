qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
experimental <- FALSE
invisible(duckdb$rapi_load_rfuns(drv@database_ref))
invisible(DBI::dbExecute(con, 'CREATE MACRO ">"(x, y) AS "r_base::>"(x, y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "=="(x, y) AS "r_base::=="(x, y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
df1 <- lineitem
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb$rel_aggregate(
  rel1,
  groups = list(duckdb$expr_reference("l_orderkey")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("sum", list(duckdb$expr_reference("l_quantity")))
      duckdb$expr_set_alias(tmp_expr, "sum")
      tmp_expr
    }
  )
)
rel3 <- duckdb$rel_filter(
  rel2,
  list(
    duckdb$expr_function(
      ">",
      list(
        duckdb$expr_reference("sum"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(300, experimental = experimental)
        } else {
          duckdb$expr_constant(300)
        }
      )
    )
  )
)
df2 <- orders
rel4 <- duckdb$rel_from_df(con, df2, experimental = experimental)
rel5 <- duckdb$rel_set_alias(rel4, "lhs")
rel6 <- duckdb$rel_set_alias(rel3, "rhs")
rel7 <- duckdb$rel_join(
  rel5,
  rel6,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("o_orderkey", rel5), duckdb$expr_reference("l_orderkey", rel6))
    )
  ),
  "inner"
)
rel8 <- duckdb$rel_project(
  rel7,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("o_orderkey", rel5), duckdb$expr_reference("l_orderkey", rel6))
      )
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderstatus")
      duckdb$expr_set_alias(tmp_expr, "o_orderstatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_totalprice")
      duckdb$expr_set_alias(tmp_expr, "o_totalprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_clerk")
      duckdb$expr_set_alias(tmp_expr, "o_clerk")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_shippriority")
      duckdb$expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_comment")
      duckdb$expr_set_alias(tmp_expr, "o_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum")
      duckdb$expr_set_alias(tmp_expr, "sum")
      tmp_expr
    }
  )
)
rel9 <- duckdb$rel_set_alias(rel8, "lhs")
df3 <- customer
rel10 <- duckdb$rel_from_df(con, df3, experimental = experimental)
rel11 <- duckdb$rel_set_alias(rel10, "rhs")
rel12 <- duckdb$rel_join(
  rel9,
  rel11,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("o_custkey", rel9), duckdb$expr_reference("c_custkey", rel11))
    )
  ),
  "inner"
)
rel13 <- duckdb$rel_project(
  rel12,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("o_custkey", rel9), duckdb$expr_reference("c_custkey", rel11))
      )
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderstatus")
      duckdb$expr_set_alias(tmp_expr, "o_orderstatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_totalprice")
      duckdb$expr_set_alias(tmp_expr, "o_totalprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_clerk")
      duckdb$expr_set_alias(tmp_expr, "o_clerk")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_shippriority")
      duckdb$expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_comment")
      duckdb$expr_set_alias(tmp_expr, "o_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum")
      duckdb$expr_set_alias(tmp_expr, "sum")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_nationkey")
      duckdb$expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_mktsegment")
      duckdb$expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    }
  )
)
rel14 <- duckdb$rel_project(
  rel13,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_totalprice")
      duckdb$expr_set_alias(tmp_expr, "o_totalprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum")
      duckdb$expr_set_alias(tmp_expr, "sum")
      tmp_expr
    }
  )
)
rel15 <- duckdb$rel_order(
  rel14,
  list(duckdb$expr_reference("o_totalprice"), duckdb$expr_reference("o_orderdate"))
)
rel16 <- duckdb$rel_limit(rel15, 100)
rel16
duckdb$rel_to_altrep(rel16)
