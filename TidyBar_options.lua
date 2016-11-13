function TidyBar_setup_options_pane()

TidyBar = {}
TidyBar.panel = CreateFrame( 'Frame', 'TidyBarPanel', UIParent )
TidyBar.panel.name = 'TidyBar'
InterfaceOptions_AddCategory( TidyBar.panel )

local position = 0

local function space()
  position = position + 1
  Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormalSmall' )
  Text:SetPoint( 'TopLeft', 20, -25  )
  Text:SetText( '' )
end



position = position + 1
Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormal' )
Text:SetPoint( 'TopLeft', 20, -25 * position )
Text:SetText( 'TidyBar' )



position = position + 1
Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormalSmall' )
Text:SetPoint( 'TopLeft', 20, -25 * position )
Text:SetText( 'Version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) )



position = position + 1
Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormal' )
Text:SetPoint( 'TopLeft', 20, -25 * position )
Text:SetText( tostring( GetAddOnMetadata( 'TidyBar', 'Notes' ) ) )



space()



position = position + 1
Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormalSmall' )
Text:SetPoint( 'TopLeft', 20, -25 * position )
Text:SetText( 'With great thanks to danltiger for the original TidyBar.' )



space()



space()



do  --  TidyBar_options.show_experience_bar
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_experience_bar', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show Experience Bar' )
  --CheckButton.tooltipText = ''
  CheckButton:SetChecked( TidyBar_options.show_experience_bar )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked()then
      TidyBar_options.show_experience_bar = true
    else
      TidyBar_options.show_experience_bar = false
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.show_artifact_power_bar
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_artifact_power_bar', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show Artifact Power Bar' )
  --CheckButton.tooltipText = ''
  CheckButton:SetChecked( TidyBar_options.show_artifact_power_bar )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked()then
      TidyBar_options.show_artifact_power_bar = true
    else
      TidyBar_options.show_artifact_power_bar = false
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.show_honor_bar
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_honor_bar', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show Honor Bar' )
  --CheckButton.tooltipText = ''
  CheckButton:SetChecked( TidyBar_options.show_honor_bar )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked()then
      TidyBar_options.show_honor_bar = true
    else
      TidyBar_options.show_honor_bar = false
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.always_show_side
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.always_show_side', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Always show the side bar(s)' )
  CheckButton.tooltipText = 'When disabled, auto-hide the right-hand vertical bars on MouseOut.'
  CheckButton:SetChecked( TidyBar_options.always_show_side )
  CheckButton:SetScript( 'OnClick', function( self )
    local alpha
    if self:GetChecked()then
      TidyBar_options.always_show_side = true
      alpha = 0
    else
      TidyBar_options.always_show_side = false
      alpha = 1
    end
    for i = 1, 12 do
      _G[ 'MultiBarRightButton'..i ]:SetAlpha( alpha )
      _G[ 'MultiBarLeftButton' ..i ]:SetAlpha( alpha )
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.show_gryphons
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_gryphons', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show gryphons' )
  CheckButton.tooltipText = 'Show the gryphons to the left and right of the main buttons.'
  CheckButton:SetChecked( TidyBar_options.show_gryphons )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked()then
      TidyBar_options.show_gryphons = true
    else
      TidyBar_options.show_gryphons = false
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.show_MainMenuBar_textured_background
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_MainMenuBar_textured_background', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show mainbar textures' )
  CheckButton.tooltipText = 'Show the texture behind the main buttons.'
  CheckButton:SetChecked( TidyBar_options.show_MainMenuBar_textured_background )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked()then
      TidyBar_options.show_MainMenuBar_textured_background = true
    else
      TidyBar_options.show_MainMenuBar_textured_background = false
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.show_macro_text
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_macro_text', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show macro text' )
  CheckButton.tooltipText = 'For any macros dragged out into any bar, show its name.'
print ( '---' )
print ( '1  --  ' .. tostring( TidyBar_options.show_macro_text ) )
  CheckButton:SetChecked( TidyBar_options.show_macro_text )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked()then
print ( '2  --  ' .. tostring( TidyBar_options.show_macro_text ) )
      TidyBar_options.show_macro_text = true
print ( '3  --  ' .. tostring( TidyBar_options.show_macro_text ) )
print ( '---' )
    else
      TidyBar_options.show_macro_text = false
    end
    TidyBar_refresh_everything()
  end)
end



space()



do  --  TidyBar_options.scale
  position = position + 1
  local scale_slider
  scale_slider = CreateFrame( 'Slider', 'TidyBar_options.scale', TidyBarPanel, 'OptionsSliderTemplate' )
  scale_slider:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( scale_slider:GetName() .. 'Text' ):SetText( 'Scale' )
  scale_slider.tooltipText = 'The scale of the buttons.  Default 1'
  scale_slider:SetMinMaxValues( 0.1, 3 )
  scale_slider:SetValueStep( 0.1 )
  scale_slider:SetValue( TidyBar_options.scale )
  scale_slider:SetScript( 'OnValueChanged', function()
    TidyBar_options.scale = scale_slider:GetValue()
    TidyBar_refresh_everything()
    if TidyBar_options.debug then
      print( 'TidyBar_options.scale ' .. tostring( TidyBar_options.scale ) )
    end
  end)


  position = position + 1
  local Button
  Button = CreateFrame( 'Button', 'TidyBar_options.scale2', TidyBarPanel, 'OptionsButtonTemplate' )
  Button:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( Button:GetName() .. 'Text' ):SetText( 'Reset' )
  Button.tooltipText = 'Reset the scale to 1'
  Button:SetScript( 'OnClick', function( self )
    TidyBar_options.scale = 1
    scale_slider:SetValue( TidyBar_options.scale )
    TidyBar_refresh_everything()
  end)
end



space()



do  --  TidyBar_options.bar_spacing
  position = position + 1
  local bar_spacing_slider
  bar_spacing_slider = CreateFrame( 'Slider', 'TidyBar_options.bar_spacing', TidyBarPanel, 'OptionsSliderTemplate' )
  bar_spacing_slider:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( bar_spacing_slider:GetName() .. 'Text' ):SetText( 'Bar spacing' )
  bar_spacing_slider.tooltipText = 'The vertical spacing between the bars.  Default 4.  Note that the experience bar (if shown) and artifact bar are not separated.'
  bar_spacing_slider:SetMinMaxValues( 0.1, 10 )
  bar_spacing_slider:SetValueStep( 0.1 )
  bar_spacing_slider:SetValue( TidyBar_options.bar_spacing )
  bar_spacing_slider:SetScript( 'OnValueChanged', function()
    TidyBar_options.bar_spacing = ( bar_spacing_slider:GetValue() * TidyBar_options.scale )
    TidyBar_refresh_everything()
    if TidyBar_options.debug then
      print( 'TidyBar_options.bar_spacing ' .. tostring( TidyBar_options.bar_spacing ) )
    end
  end)


  position = position + 1
  local Button
  Button = CreateFrame( 'Button', 'TidyBar_options.bar_spacing2', TidyBarPanel, 'OptionsButtonTemplate' )
  Button:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( Button:GetName() .. 'Text' ):SetText( 'Reset' )
  Button.tooltipText = 'Reset the bar spacing to 4'
  Button:SetScript( 'OnClick', function( self )
    TidyBar_options.bar_spacing = ( 4 * TidyBar_options.scale )
    bar_spacing_slider:SetValue( TidyBar_options.bar_spacing )
    TidyBar_refresh_everything()
  end)
end



space()



do  --  TidyBar_options.bar_height
  position = position + 1
  local main_area_positioning_slider
  main_area_positioning_slider = CreateFrame( 'Slider', 'TidyBar_options.bar_height', TidyBarPanel, 'OptionsSliderTemplate' )
  main_area_positioning_slider:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( main_area_positioning_slider:GetName() .. 'Text' ):SetText( 'Bar height' )
  main_area_positioning_slider.tooltipText = 'The height of the experience, reputation, honor and artifact bars.'
  main_area_positioning_slider:SetMinMaxValues( 1, 24 )
  main_area_positioning_slider:SetValueStep( 1 )
  main_area_positioning_slider:SetValue( TidyBar_options.main_area_positioning )
  main_area_positioning_slider:SetScript( 'OnValueChanged', function()
    TidyBar_options.bar_height = main_area_positioning_slider:GetValue()
    TidyBar_refresh_everything()
    if TidyBar_options.debug then
      print( 'TidyBar_options.main_area_positioning ' .. tostring( TidyBar_options.bar_height ) )
    end
  end)


  position = position + 1
  local Button
  Button = CreateFrame( 'Button', 'TidyBar_options.bar_height2', TidyBarPanel, 'OptionsButtonTemplate' )
  Button:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( Button:GetName() .. 'Text' ):SetText( 'Reset' )
  Button.tooltipText = 'Reset the bar height to 8.'
  Button:SetScript( 'OnClick', function( self )
    TidyBar_options.bar_height = 8
    main_area_positioning_slider:SetValue( TidyBar_options.bar_height )
    TidyBar_refresh_everything()
  end)
end



space()



do  --  TidyBar_options.main_area_positioning
  position = position + 1
  local main_area_positioning_slider
  main_area_positioning_slider = CreateFrame( 'Slider', 'TidyBar_options.main_area_positioning', TidyBarPanel, 'OptionsSliderTemplate' )
  main_area_positioning_slider:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( main_area_positioning_slider:GetName() .. 'Text' ):SetText( 'Main area positioning' )
  main_area_positioning_slider.tooltipText = 'The position of the main area.'
  main_area_positioning_slider:SetMinMaxValues( 1, GetScreenWidth() )
  -- You'd think this would prevent the area from moving off the screen to the wrong.  It does not.
  -- .. even if it did, I may have scaling issues.
  --main_area_positioning_slider:SetMinMaxValues( 1, ( GetScreenWidth() - MainMenuBar:GetWidth() ) )
  main_area_positioning_slider:SetValueStep( 1 )
  main_area_positioning_slider:SetValue( TidyBar_options.main_area_positioning )
  main_area_positioning_slider:SetScript( 'OnValueChanged', function()
    TidyBar_options.main_area_positioning = main_area_positioning_slider:GetValue()
    TidyBar_refresh_everything()
    if TidyBar_options.debug then
      print( 'TidyBar_options.main_area_positioning ' .. tostring( TidyBar_options.main_area_positioning ) )
    end
  end)


  position = position + 1
  local Button
  Button = CreateFrame( 'Button', 'TidyBar_options.main_area_positioning2', TidyBarPanel, 'OptionsButtonTemplate' )
  Button:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( Button:GetName() .. 'Text' ):SetText( 'Reset' )
  Button.tooltipText = 'Reset the main area positioning to (roughly) the middle.'
  -- Maybe I should have it actually reset to the middle.
  --   .. or perhaps alongside the chat window, but that'll be bad for a tweaked layout.
  Button:SetScript( 'OnClick', function( self )
    TidyBar_options.main_area_positioning = 425
    main_area_positioning_slider:SetValue( TidyBar_options.main_area_positioning )
    TidyBar_refresh_everything()
  end)
end



space()



space()



do  --  TidyBar_options.debug
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.debug', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show debug messages' )
  CheckButton.tooltipText = ''
  CheckButton:SetChecked( TidyBar_options.debug )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked()then
      print( 'TidyBar:  Debugging enabled' )
      TidyBar_options.debug = true
    else
      print( 'TidyBar:  Debugging disabled' )
      TidyBar_options.debug = false
    end
    --TidyBar_refresh_everything()
  end)
end


end
