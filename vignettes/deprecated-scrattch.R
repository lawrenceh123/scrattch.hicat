context("test-scrattch")
library(scrattch.hicat)

test_WGCNA_louvain_consistent <- function()
{
  require(mclust)
  de.param = de_param(q1.th=0.5, de.score.th=40)
  result = onestep_clust(tasic16.dat,dim.method="WGCNA", de.param = de.param)
  adj.rand.index=adjustedRandIndex(result$cl, tasic16.cl[names(result$cl)])
  print(adj.rand.index)
  adj.rand.index
}

test_PCA_louvain_consistent <- function()
{
  require(mclust)
  de.param = de_param(q1.th=0.5, de.score.th=40)
  result = onestep_clust(tasic16.dat,dim.method="PCA", de.param = de.param)
  adj.rand.index=adjustedRandIndex(result$cl, tasic16.cl[names(result$cl)])
  print(adj.rand.index)
  adj.rand.index
}

test_WGCNA_ward_consistent <- function()
{
  require(mclust)
  de.param = de_param(q1.th=0.5, de.score.th=40)
  result = onestep_clust(tasic16.dat, dim.method="WGCNA", method="ward.D", de.param = de.param)
  adj.rand.index=adjustedRandIndex(result$cl, tasic16.cl[names(result$cl)])
  print(adj.rand.index)
  adj.rand.index
}

test_PCA_ward_consistent <- function()
{
  require(mclust)
  de.param = de_param(q1.th=0.5, de.score.th=40)
  result = onestep_clust(tasic16.dat,dim.method="PCA", method="ward.D", de.param = de.param)
  adj.rand.index=adjustedRandIndex(result$cl, tasic16.cl[names(result$cl)])
  print(adj.rand.index)
  adj.rand.index
}

test_markers <- function()
{
  de.param = de_param(q1.th=0.5, de.score.th=40)
  display.result= display_cl(tasic16.cl, tasic16.dat, de.param = de.param)
  return(length(display.result$markers))
}

test_PCA_ward_iterclust_consistent <- function()
{
  require(mclust)
  de.param = de_param(q1.th=0.5, de.score.th=40)
  result = iter_clust(tasic16.dat,dim.method="PCA", method="ward.D", de.param = de.param)
  adj.rand.index=adjustedRandIndex(result$cl, tasic16.cl[names(result$cl)])
  print(adj.rand.index)
  adj.rand.index
}

test_PCA_louvain_iterclust_consistent <- function()
{
  require(mclust)
  de.param = de_param(q1.th=0.5, de.score.th=40)
  result = iter_clust(tasic16.dat,dim.method="PCA", method="louvain", de.param = de.param)
  adj.rand.index=adjustedRandIndex(result$cl, tasic16.cl[names(result$cl)])
  print(adj.rand.index)
  adj.rand.index
}


test_WGCNA_iterclust_consistent <- function()
{
  require(mclust)
  de.param = de_param(q1.th=0.5, de.score.th=40)
  result = iter_clust(tasic16.dat,dim.method="WGCNA", method="ward.D", de.param = de.param)
  merge.result = merge_cl(tasic16.dat, cl=result$cl, de.param = de.param, rd.dat= t(tasic16.dat[result$markers,]))
  compare.result = compare_annotate(merge.result$cl, ref.cl, ref.cl.df)
  compare.result$g
  adj.rand.index=adjustedRandIndex(merge.result$cl, tasic16.cl[names(result$cl)])
  print(adj.rand.index)
  adj.rand.index
}


test_directional <- function()
{
  require(mclust)
  de.param = de_param(q1.th=0.5, de.score.th=40)
  result = onestep_clust(tasic16.dat, dim.method="WGCNA", method="ward.D", de.param = de.param, merge.type="directional")
  de.param = de_param(q1.th=0.5, de.score.th=200)
  merge.result = merge_cl(tasic16.dat, cl=result$cl, de.param = de.param, rd.dat= Matrix::t(tasic16.dat[result$markers,]), merge.type="directional")
  merge.fast.result = merge_cl_fast(tasic16.dat, cl=result$cl, de.param = de.param, rd.dat.t= tasic16.dat[result$markers,], merge.type="directional")
  adj.rand.index=adjustedRandIndex(merge.result$cl, merge.fast.result$cl)
  adj.rand.index
}

test_merge <- function()
{
  require(mclust)
  de.param = de_param(q1.th=0.5, de.score.th=100)
  merge.result = merge_cl(tasic16.dat, cl=result$cl, de.param = de.param, rd.dat= Matrix::t(tasic16.dat[result$markers,]))
  merge.fast.result = merge_cl_fast(tasic16.dat, cl=result$cl, de.param = de.param, rd.dat.t= tasic16.dat[result$markers,])
  adj.rand.index=adjustedRandIndex(merge.result$cl, merge.fast.result$cl)
  adj.rand.index
}


test_consensus_directional <- function()
{
  require(mclust)
  de.param = de_param(q1.th=0.5, de.score.th=50)
  consensus.result= run_consensus_clust(tasic16.dat, de.param = de.param, merge.type="directional",niter=20, override=TRUE)
  cl = consensus.result$cl.result$cl
  adj.rand.index=adjustedRandIndex(cl, tasic16.cl[names(cl)])
  print(adj.rand.index)
  adj.rand.index
}


test_bigMatrix <- function()
{
  set.seed(1234)
  dat1 = dat2= matrix(0, nrow=5, ncol=10)
  dat1[sample(1:50,10)] = sample(1:100, 10)
  dat2[sample(1:50,10)] = sample(1:100, 10)
  dat.list = list(Matrix(dat1,sparse=TRUE), Matrix(dat2,sparse=TRUE))
  comb.dat = combine_dat(dat.list) 
  tmp.dat1 = get_cols(comb.dat, 1:10)
  tmp.dat2 = get_cols(comb.dat, 11:20)
  sum(abs(tmp.dat1 - dat1)) + sum(abs(tmp.dat2 - dat2))
}

test_that("Test clustering", {
  expect_gt(test_WGCNA_louvain_consistent(), 0.3)
  expect_gt(test_PCA_louvain_consistent(), 0.3)
  expect_gt(test_WGCNA_ward_consistent(), 0.3)
  expect_gt(test_PCA_ward_consistent(), 0.3)
})

test_that("Test merging clusters based on directional DE gene criterion", {
  expect_gt(test_directional(), 0.9)
})

test_that("Test DE genes calculation", {
  expect_gt(test_markers(), 100)
})



test_that("Test Merging", {
  expect_gt(test_merge(), 0.9)
})

test_that("Test bigMatrix container",{
  expect_equal(test_bigMatrix(), 0)
})



test_that("Consensus clustering",{
  expect_gt(test_consensus_directional(),0.1)
})



