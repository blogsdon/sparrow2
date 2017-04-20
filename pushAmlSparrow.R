system('curl -O http://leelab-data.cs.washington.edu/amlCodes.rda')

load('amlCodes.rda')

geneNames <- rownames(basesFreq)

rownames(basesFreq) <- 1:nrow(basesFreq)

basesFreq <- data.frame(basesFreq,stringsAsFactors=F)

basesFreq$geneName <- geneNames

basesFreq <- dplyr::arrange(basesFreq,desc(sparrow1))

amlSparrowScores <- dplyr::select(basesFreq,geneName,sparrow1)

colnames(amlSparrowScores)[c(2)] <- 'sparrowScore'

fileName <- 'amlSparrowScores.csv'

synapseFolderId <- 'syn9650583'

annos <- c('dataType'='analysis',
  'method'='sparrow',
  'disease'='acuteMyeloidLeukemia')

comment <- 'sparrow scores for AML from Logsdon et al. 2015'

executedVector<-githubr::getPermlink('blogsdon/sparrow2','pushAmlSparrow.R')

activityName1 <- 'push sparrow scores to synapse'

activityDescription1 <- 'pull sparrow scores from Lee lab server and push to Synapse'

synapseClient::synapseLogin()

write.csv(amlSparrowScores,file=fileName,quote=F)

foo <- synapseClient::File(fileName,
                           parentId=synapseFolderId,
                           versionComment=comment)

synapseClient::synSetAnnotations(foo) = as.list(annos)

foo = synapseClient::synStore(foo,
               executed = as.list(executedVector),
               activityName = activityName1,
               activityDescription = activityDescription1)
