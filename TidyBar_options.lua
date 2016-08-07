function TidyBar_create_options_pane()

TidyBar = {}
TidyBar.panel = CreateFrame( 'Frame', 'TidyBarPanel', UIParent )
TidyBar.panel.name = 'TidyBar'
InterfaceOptions_AddCategory( TidyBar.panel )

local position

local function space()
  Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormalSmall' )
  Text:SetPoint( 'TOPLEFT', 20, -25  )
  Text:SetText( '' )
end



position = 1
Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormal' )
Text:SetPoint( 'TOPLEFT', 20, -25 * position )
Text:SetText( 'TidyBar' )



position = 2
Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormalSmall' )
Text:SetPoint( 'TOPLEFT', 20, -25 * position )
Text:SetText( 'Version ' .. tostring( GetAddOnMetadata( 'TidyBar', 'Version' ) ) )



position = 3
Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormal' )
Text:SetPoint( 'TOPLEFT', 20, -25 * position )
Text:SetText( tostring( GetAddOnMetadata( 'TidyBar', 'Notes' ) ) )



position = 4
space()



position = 5
Text = TidyBar.panel:CreateFontString( nil, UIParent, 'GameFontNormalSmall' )
Text:SetPoint( 'TOPLEFT', 20, -25 * position )
Text:SetText( 'With great thanks to danltiger for the original TidyBar.' )



position = 6
space()



position = 7
space()



position = 8
local CheckButton
CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_experience_bar', TidyBarPanel, 'OptionsCheckButtonTemplate' )
CheckButton:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show Experience Bar' )
CheckButton.tooltipText = 'The reputation bar can still be shown.'
CheckButton:SetChecked( TidyBar_options.show_experience_bar )
CheckButton:SetScript( 'OnClick', function( self )
  if self:GetChecked()then
    TidyBar_options.show_experience_bar = true
  else
    TidyBar_options.show_experience_bar = false
  end
  TidyBar_RefreshPositions()
end)



position = 9
local CheckButton
CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.hide_sidebar_on_mouseout', TidyBarPanel, 'OptionsCheckButtonTemplate' )
CheckButton:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Autohide sidebar' )
CheckButton.tooltipText = 'Hide the right-hand bar(s) when the mouse is not over them.'
CheckButton:SetChecked( TidyBar_options.hide_sidebar_on_mouseout )
CheckButton:SetScript( 'OnClick', function( self )
  if self:GetChecked()then
    TidyBar_options.hide_sidebar_on_mouseout = true
  else
    TidyBar_options.hide_sidebar_on_mouseout = false
  end
  -- TODO - Immediately hide the sidebar when the option is enabled.
  TidyBar_RefreshPositions()
end)



position = 10
local CheckButton
CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_gryphons', TidyBarPanel, 'OptionsCheckButtonTemplate' )
CheckButton:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show gryphons' )
CheckButton.tooltipText = 'Show the gryphons to the left and right of the main buttons.'
CheckButton:SetChecked( TidyBar_options.show_gryphons )
CheckButton:SetScript( 'OnClick', function( self )
  if self:GetChecked()then
    TidyBar_options.show_gryphons = true
  else
    TidyBar_options.show_gryphons = false
  end
  TidyBar_RefreshPositions()
end)



position = 11
local CheckButton
CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_MainMenuBar_textured_background', TidyBarPanel, 'OptionsCheckButtonTemplate' )
CheckButton:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show mainbar textures' )
CheckButton.tooltipText = 'Show the texture behind the main buttons.'
CheckButton:SetChecked( TidyBar_options.show_MainMenuBar_textured_background )
CheckButton:SetScript( 'OnClick', function( self )
  if self:GetChecked()then
    TidyBar_options.show_MainMenuBar_textured_background = true
  else
    TidyBar_options.show_MainMenuBar_textured_background = false
  end
  TidyBar_RefreshPositions()
end)



position = 12
local CheckButton
CheckButton = CreateFrame( 'CheckButton', 'TidyBar_options.show_macro_text', TidyBarPanel, 'OptionsCheckButtonTemplate' )
CheckButton:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( CheckButton:GetName() .. 'Text' ):SetText( 'Show macro text' )
CheckButton.tooltipText = 'For any macros dragged out into any bar, show its name.'
CheckButton:SetChecked( TidyBar_options.show_macro_text )
CheckButton:SetScript( 'OnClick', function( self )
  if self:GetChecked()then
    TidyBar_options.show_macro_text = true
  else
    TidyBar_options.show_macro_text = false
  end
  TidyBar_RefreshPositions()
end)



position = 13
space()



position = 14
local scale_slider
scale_slider = CreateFrame( 'Slider', 'TidyBar_options.scale', TidyBarPanel, 'OptionsSliderTemplate' )
scale_slider:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( scale_slider:GetName() .. 'Text' ):SetText( 'Scale' )
scale_slider.tooltipText = 'The scale of the buttons.  Default 1'
scale_slider:SetMinMaxValues( 0.1, 3 )
scale_slider:SetValueStep( 0.1 )
scale_slider:SetValue( TidyBar_options.scale )
scale_slider:SetScript( 'OnValueChanged', function()
  TidyBar_options.scale = scale_slider:GetValue()
  TidyBar_RefreshPositions()
end)



position = 15
local Button
Button = CreateFrame( 'Button', 'TidyBar_options.scale2', TidyBarPanel, 'OptionsButtonTemplate' )
Button:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( Button:GetName() .. 'Text' ):SetText( 'Reset' )
Button.tooltipText = 'Reset the scale to 1'
Button:SetScript( 'OnClick', function( self )
  TidyBar_options.scale = 1
  scale_slider:SetValue( TidyBar_options.scale )
  TidyBar_RefreshPositions()
end)



position = 16
space()



position = 17
local bar_spacing_slider
bar_spacing_slider = CreateFrame( 'Slider', 'TidyBar_options.bar_spacing', TidyBarPanel, 'OptionsSliderTemplate' )
bar_spacing_slider:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( bar_spacing_slider:GetName() .. 'Text' ):SetText( 'Scale' )
bar_spacing_slider.tooltipText = 'The vertical spacing between the bars.  Default 4.  Note that the experience bar(if shown) and reputation bar are not separated.'
bar_spacing_slider:SetMinMaxValues( 0.1, 10 )
bar_spacing_slider:SetValueStep( 0.1 )
bar_spacing_slider:SetValue( TidyBar_options.bar_spacing )
bar_spacing_slider:SetScript( 'OnValueChanged', function()
  TidyBar_options.bar_spacing = ( bar_spacing_slider:GetValue() * TidyBar_options.scale )
  TidyBar_RefreshPositions()
end)



position = 18
local Button
Button = CreateFrame( 'Button', 'TidyBar_options.bar_spacing2', TidyBarPanel, 'OptionsButtonTemplate' )
Button:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( Button:GetName() .. 'Text' ):SetText( 'Reset' )
Button.tooltipText = 'Reset the bar spacing to 4'
Button:SetScript( 'OnClick', function( self )
  TidyBar_options.bar_spacing = ( 4 * TidyBar_options.scale )
  bar_spacing_slider:SetValue( TidyBar_options.bar_spacing )
  TidyBar_RefreshPositions()
end)



position = 19
space()



-- The position of the middle buttons.
--   On a 1920 x 1080 screen:
--       500 is the middle
--      1375 is the left side
--         1 is more to the right.
--         0 crosses the streams.
position = 20
local main_area_positioning_slider
main_area_positioning_slider = CreateFrame( 'Slider', 'TidyBar_options.main_area_positioning', TidyBarPanel, 'OptionsSliderTemplate' )
main_area_positioning_slider:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( main_area_positioning_slider:GetName() .. 'Text' ):SetText( 'Main area positioning' )
main_area_positioning_slider.tooltipText = 'The position of the main area.  There is a right-side limit.'
-- I have no idea why these numbers do what they do.
main_area_positioning_slider:SetMinMaxValues( 0.1, 1375 )
main_area_positioning_slider:SetValueStep( 25 )
main_area_positioning_slider:SetValue( TidyBar_options.main_area_positioning )
main_area_positioning_slider:SetScript( 'OnValueChanged', function()
  -- ( - 1375) reverses the direction of the slider.
  TidyBar_options.main_area_positioning = ( main_area_positioning_slider:GetValue() - 1375 )
  TidyBar_RefreshPositions()
end)




position = 21
local Button
Button = CreateFrame( 'Button', 'TidyBar_options.main_area_positioning2', TidyBarPanel, 'OptionsButtonTemplate' )
Button:SetPoint( 'TOPLEFT', 20, -20 * position )
getglobal( Button:GetName() .. 'Text' ):SetText( 'Reset' )
Button.tooltipText = 'Reset the main area positioning to (roughly) the middle.'
Button:SetScript( 'OnClick', function( self )
  -- Why do I have to repeat these options?  Who knows!
  TidyBar_options.main_area_positioning = 500
  main_area_positioning_slider:SetValue( TidyBar_options.main_area_positioning )
  TidyBar_options.main_area_positioning = 500
  main_area_positioning_slider:SetValue( TidyBar_options.main_area_positioning )
  TidyBar_RefreshPositions()
end)


end
