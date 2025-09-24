#tag Class
Protected Class App
Inherits MCPKit.ServerApplication
	#tag Event , Description = 43616C6C207468697320746F20706572666F726D20616E7920726571756972656420636F6E66696775726174696F6E207374657073206265666F726520746865207365727665722072756E732E2054686973206576656E742069732072616973656420696D6D6564696174656C79206265666F726520746865206052756E282960206576656E742E
		Sub Configure()
		  Self.Name = "mcpweb"
		  
		  Var apiKey As String = CommandLineParser.StringValue("apikey", "")
		  RegisterTools(New KagiSearchTool(apiKey))
		  
		End Sub
	#tag EndEvent

	#tag Event , Description = 546865206170706C69636174696F6E2069732061626F757420746F20706172736520616E79206F7074696F6E732070617373656420746F20746865206170706C69636174696F6E2E20596F752073686F756C64207265676973746572206F7074696F6E7320686572652E
		Sub WillParseOptions()
		  // Add your command line options here.
		  
		  Self.CommandLineParser.AddOption("k", "apikey", "The Kagi API key to use.", _
		  MCPKit.OptionTypes.String, True)
		  
		End Sub
	#tag EndEvent


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Verbose"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
