////
////  Cloud.h
////
////
////  Created by Mindy Lou on 10/14/18.
////
//
//#import <CoreData/CoreData.h>
//
///// Allows processes to register with a cloud to be notified of updates to
///// the channel, implementing a lightweight publish-subscribe protocol for
///// RSS feeds.
/////
///// Example: <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="pingMe" protocol="soap"/>
/////
///// <cloud> is an optional sub-element of <channel>.
/////
///// It specifies a web service that supports the rssCloud interface which can
///// be implemented in HTTP-POST, XML-RPC or SOAP 1.1.
/////
///// Its purpose is to allow processes to register with a cloud to be notified
///// of updates to the channel, implementing a lightweight publish-subscribe
///// protocol for RSS feeds.
/////
///// <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="myCloud.rssPleaseNotify" protocol="xml-rpc" />
/////
///// In this example, to request notification on the channel it appears in,
///// you would send an XML-RPC message to rpc.sys.com on port 80, with a path
///// of /RPC2. The procedure to call is myCloud.rssPleaseNotify.
/////
///// A full explanation of this element and the rssCloud interface is here:
///// http://cyber.law.harvard.edu/rss/soapMeetsRss.html#rsscloudInterface
//@interface Cloud : NSManagedObject
//
///// The domain to register notification to.
//@property (nullable, nonatomic) NSString *domain;
//
///// The port to connect to.
//@property (nonatomic) NSNumber *port;
//
///// The path to the RPC service. e.g. "/RPC2".
//@property (nullable, nonatomic) NSString *path;
//
///// The procedure to call. e.g. "myCloud.rssPleaseNotify" .
//@property (nullable, nonatomic) NSString *registerProcedure;
//
///// The `protocol` specification. Can be HTTP-POST, XML-RPC or SOAP 1.1 -
///// Note: "protocol" is a reserved keyword, so `protocolSpecification`
///// is used instead and refers to the `protocol` attribute of the `cloud`
///// element.
//@property (nullable, nonatomic) NSString *protocolSpecification;
//
//@end
