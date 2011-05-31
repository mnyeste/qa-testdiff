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

@log = Logger.new(STDOUT)
@log.level = Logger::DEBUG

eclipse  = parseXML("data/eclipse")
surefire =  parseXML("data/surefire")

@log.info(" --- Processing finished ---")
@log.info("Eclipse: #{eclipse.length}")

print("Eclipse: ",eclipse.length)

@log.close