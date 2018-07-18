do  --  Default options
  TidyBar_options = {}

  TidyBar_options.show_StatusTrackingBarManager = true
  TidyBar_options.hide_corner_on_mouseout = true
  TidyBar_options.hide_side_on_mouseout = true
  TidyBar_options.show_macro_text = false

  TidyBar_options.show_textured_background_main = false
  TidyBar_options.show_textured_background_corner = false
  TidyBar_options.show_textured_background_petbattle = false

  TidyBar_options.main_area_positioning = 0

  TidyBar_options.debug = false
end



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
Text:SetText( 'TidyBar - Version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) )



position = position + 1
Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormal' )
Text:SetPoint( 'TopLeft', 20, -25 * position )
Text:SetText( tostring( GetAddOnMetadata( 'TidyBar', 'Notes' ) ) )



position = position + 1
Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormalSmall' )
Text:SetPoint( 'TopLeft', 20, -25 * position )
Text:SetText( 'With great thanks to danltiger for the original TidyBar.' )



space()



space()



do  --  TidyBar_options.show_StatusTrackingBarManager
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_StatusTrackingBarManager', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show Status Tracking Bar' )
  CheckButton.tooltipText = 'The combined experience/etc bar, at the bottom.'
  CheckButton:SetChecked( TidyBar_options.show_StatusTrackingBarManager )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.show_StatusTrackingBarManager = true
      -- I don't know why TidyBar_refresh_everything() doesn't do this..
      MainMenuBar:SetPoint( 'Bottom', UIParent, 'Bottom', TidyBar_options.main_area_positioning, StatusTrackingBarManager.SingleBarLarge:GetHeight() )
    else
      TidyBar_options.show_StatusTrackingBarManager = false
      -- I don't know why TidyBar_refresh_everything() doesn't do this..
      MainMenuBar:SetPoint( 'Bottom', UIParent, 'Bottom', TidyBar_options.main_area_positioning )
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.hide_side_on_mouseout
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.hide_side_on_mouseout', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Hide the side bar' )
  CheckButton.tooltipText = 'When enabled, auto-hide the right-hand vertical bars on MouseOut.'
  CheckButton:SetChecked( TidyBar_options.hide_side_on_mouseout )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.hide_side_on_mouseout = true
      TidyBar_options.mouseout_alpha_side = 0
    else
      TidyBar_options.hide_side_on_mouseout = false
      TidyBar_options.mouseout_alpha_side = 1
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.hide_corner_on_mouseout
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.hide_corner_on_mouseout', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Hide the corner bar' )
  CheckButton.tooltipText = 'When enabled, auto-hide the bottom-left buttons and bags on MouseOut.'
  CheckButton:SetChecked( TidyBar_options.hide_corner_on_mouseout )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.hide_corner_on_mouseout = true
    else
      TidyBar_options.hide_corner_on_mouseout = false
    end
    TidyBar_refresh_everything()
  end)
end



do  --  TidyBar_options.show_textured_background_petbattle
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_textured_background_petbattle', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show pet battle background' )
  CheckButton.tooltipText = 'Show the background behind the pet battle UI.'
  CheckButton:SetChecked( TidyBar_options.show_textured_background_petbattle )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.show_textured_background_petbattle = true
    else
      TidyBar_options.show_textured_background_petbattle = false
    end
    TidyBar_refresh_everything()
  end)
end


-- TODO - textures would need to be reworked..
--[[
do  --  TidyBar_options.show_textured_background_main
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_textured_background_main', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show main bar background' )
  CheckButton.tooltipText = 'Show the background behind the main buttons.'
  CheckButton:SetChecked( TidyBar_options.show_textured_background_main )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.show_textured_background_main = true
    else
      TidyBar_options.show_textured_background_main = false
    end
    TidyBar_refresh_everything()
  end)
end
--]]


--[[
do  --  TidyBar_options.show_textured_background_corner
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_textured_background_corner', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show corner background' )
  CheckButton.tooltipText = 'Show the  behind the corner micro buttons and bags.'
  CheckButton:SetChecked( TidyBar_options.show_textured_background_corner )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.show_textured_background_corner = true
    else
      TidyBar_options.show_textured_background_corner = false
    end
    TidyBar_refresh_everything()
  end)
end
--]]


do  --  TidyBar_options.show_macro_text
  position = position + 1
  local CheckButton
  CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_macro_text', TidyBarPanel, 'OptionsCheckButtonTemplate' )
  CheckButton:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show macro text' )
  CheckButton.tooltipText = 'For any macros dragged out into any bar, show its name.'
  CheckButton:SetChecked( TidyBar_options.show_macro_text )
  CheckButton:SetScript( 'OnClick', function( self )
    if self:GetChecked() then
      TidyBar_options.show_macro_text = true
    else
      TidyBar_options.show_macro_text = false
    end
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
  local width = ( ( GetScreenWidth() - MainMenuBar:GetWidth() ) / 2 )
  main_area_positioning_slider:SetMinMaxValues( ( -1 * width ), width )
  main_area_positioning_slider:SetValueStep( 1 )
  main_area_positioning_slider:SetValue( TidyBar_options.main_area_positioning )
  main_area_positioning_slider:SetScript( 'OnValueChanged', function()
    TidyBar_options.main_area_positioning = main_area_positioning_slider:GetValue()
    TidyBar_refresh_everything()
    -- Show the corner while positioning the main area.
    MicroButtonAndBagsBar:SetAlpha( 1 )
    if TidyBar_options.debug then
      print( 'TidyBar_options.main_area_positioning ' .. tostring( TidyBar_options.main_area_positioning ) )
    end
  end)


  position = position + 1
  local Button
  Button = CreateFrame( 'Button', 'TidyBar_options.main_area_positioning2', TidyBarPanel, 'OptionsButtonTemplate' )
  Button:SetPoint( 'TopLeft', 20, -20 * position )
  getglobal( Button:GetName() .. 'Text' ):SetText( 'Reset' )
  Button.tooltipText = 'Reset the main area positioning to the middle.'
  Button:SetScript( 'OnClick', function( self )
    TidyBar_options.main_area_positioning = 0
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
    if self:GetChecked() then
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
