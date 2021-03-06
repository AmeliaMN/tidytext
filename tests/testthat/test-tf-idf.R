context("tf-idf calculation")

w <- data_frame(document = rep(1:2, each = 5),
                word = c("the", "quick", "brown", "fox", "jumped",
                         "over", "the", "lazy", "brown", "dog"),
                frequency = c(1, 1, 1, 1, 2,
                              1, 1, 1, 1, 2))

test_that("Can calculate TF-IDF", {
  result <- w %>%
    bind_tf_idf(word, document, frequency)

  expect_equal(select(w, document, word, frequency),
               select(result, document, word, frequency))

  expect_is(result, "tbl_df")
  expect_is(result$tf, "numeric")
  expect_is(result$idf, "numeric")
  expect_is(result$tf_idf, "numeric")

  expect_equal(result$tf, rep(c(1 / 6, 1 / 6, 1 / 6, 1 / 6, 1 / 3), 2))
  expect_equal(result$idf[1:4], c(0, log(2), 0, log(2)))
  expect_equal(result$tf_idf, result$tf * result$idf)

  # preserves but ignores groups
  result2 <- w %>%
    group_by(document) %>%
    bind_tf_idf(word, document, frequency)

  #expect_equal(result, ungroup(result2))
  expect_equal(length(groups(result2)), 1)
  expect_equal(as.character(groups(result2)[[1]]), "document")
})
