unit UXMLLoader;

interface

uses XML.XMLDoc, XML.XMLIntf, Vcl.Forms;

type
  TXMLLoader = class
    private
       XmlFile : TXMLDocument;

        procedure Clear();
    public
      constructor Create(ownForm: TForm);
      function XMLContentFromText(xmlText: String):IXMLNode;
      function XMLContentFromFile(pathToFile: String):IXMLNode;
end;

var
  XMLLoader: TXMLLoader;

implementation

constructor TXMLLoader.Create(ownForm: TForm);
begin
  Self.XmlFile:=TXMLDocument.Create(ownForm);
end;

function TXMLLoader.XMLContentFromText(xmlText: String):IXMLNode;
begin
  Clear();

  Self.XmlFile.LoadFromXML(xmlText);
  Self.XmlFile.Active:=true;

  Result:=Self.XmlFile.DocumentElement;
end;

function TXMLLoader.XMLContentFromFile(pathToFile: String):IXMLNode;
begin
  Clear();

  Self.XmlFile.LoadFromFile(pathToFile);
  Self.XmlFile.Active:=true;

  Result:=Self.XmlFile.DocumentElement;
end;

procedure TXMLLoader.Clear();
begin
  Self.XmlFile.XML.Clear;
  Self.XmlFile.Active:=false;
end;

end.
