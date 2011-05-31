require 'rexml/document'
require 'logger'

include REXML

def parseXML(folder)

  testcases = Array.new

  @log.info(" --- Processing #{folder}")

  Dir.glob(File.join(folder,'*.xml')) do |filename|

    origcount = testcases.length
    @log.debug("Parsing: #{filename}")

    xmldoc = Document.new(File.new(filename))
    XPath.each(xmldoc, "//testcase")  { |e| testcases << e.attributes["classname"]+"."+e.attributes["name"] }

    @log.debug("Found #{testcases.length - origcount} testcases")
  end

  return testcases

end

def logDifferences(minuend, subtrahend)
  difference = minuend - subtrahend
  @log.info("Difference: #{difference.length}")
  @log.info("--- Testcase list begins ---")
  difference.each {|e| @log.info(e)}
  @log.info("--- Testcase list ends   ---")
end

@log = Logger.new(STDOUT)
@log.formatter = proc { |severity, datetime, progname, msg| "#{severity} - #{datetime}: #{msg}\n" }
@log.level = Logger::INFO

eclipse  = parseXML("data/eclipse")
surefire =  parseXML("data/surefire")

@log.info(" --- Processing finished ---")
@log.info("Eclipse  : #{eclipse.length}")
@log.info("Surefire : #{surefire.length}")

@log.info("--- Run only with Eclipse ---")
logDifferences(eclipse, surefire)
@log.info("--- Run only with Surefire ---")
logDifferences(surefire, eclipse)

@log.close