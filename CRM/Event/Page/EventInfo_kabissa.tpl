{*
 +--------------------------------------------------------------------+
 | CiviCRM version 3.4                                                |
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC (c) 2004-2011                                |
 +--------------------------------------------------------------------+
 | This file is a part of CiviCRM.                                    |
 |                                                                    |
 | CiviCRM is free software; you can copy, modify, and distribute it  |
 | under the terms of the GNU Affero General Public License           |
 | Version 3, 19 November 2007 and the CiviCRM Licensing Exception.   |
 |                                                                    |
 | CiviCRM is distributed in the hope that it will be useful, but     |
 | WITHOUT ANY WARRANTY; without even the implied warranty of         |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.               |
 | See the GNU Affero General Public License for more details.        |
 |                                                                    |
 | You should have received a copy of the GNU Affero General Public   |
 | License and the CiviCRM Licensing Exception along                  |
 | with this program; if not, contact CiviCRM LLC                     |
 | at info[AT]civicrm[DOT]org. If you have questions about the        |
 | GNU Affero General Public License or the licensing of CiviCRM,     |
 | see the CiviCRM license FAQ at http://civicrm.org/licensing        |
 +--------------------------------------------------------------------+
 | Customization Kabissa                                              |
 | Bug #442                                                           |
 | set up event registration form with "yes/no/maybe" options         |
 | Author : Erik Hommel                                               |
 | Date : 17 May 2012                                                 |
 +--------------------------------------------------------------------+
 | Customization Kabissa                                              |
 | Bug #513                                                           |
 | add role to who's coming part                                      |
 | Author : Erik Hommel                                               |
 | Date : 13 June 2012                                                |
 +--------------------------------------------------------------------+
 | Customization Kabissa                                              |
 | Bug #540                                                           |
 | remove price set information                                       |
 | Author : Erik Hommel                                               |
 | Date : 13 June 2012                                                |
 +--------------------------------------------------------------------+
*}
{* this template is used for displaying event information *}

{if $registerClosed }
<div class="spacer"></div>
<div class="messages status">
  <div class="icon inform-icon"></div>
     &nbsp;{ts}Registration is closed for this event{/ts}
  </div>
{/if}
<div class="vevent crm-block crm-event-info-form-block">
	<div class="event-info">
	
	{if $event.summary}
	    <div class="crm-section event_summary-section">{$event.summary}</div>
	{/if}
	{if $event.description}
	    <div class="crm-section event_description-section summary">{$event.description}</div>
	{/if}
	<div class="crm-section event_date_time-section">
	    <div class="label"><label>{ts}When{/ts}</label></div>
	    <div class="content">
            <abbr class="dtstart" title="{$event.event_start_date|crmDate}">
            {$event.event_start_date|crmDate}</abbr>
            {if $event.event_end_date}
                &nbsp; {ts}through{/ts} &nbsp;
                {* Only show end time if end date = start date *}
                {if $event.event_end_date|date_format:"%Y%m%d" == $event.event_start_date|date_format:"%Y%m%d"}
                    <abbr class="dtend" title="{$event.event_end_date|crmDate:0:1}">
                    {$event.event_end_date|crmDate:0:1}
                    </abbr>        
                {else}
                    <abbr class="dtend" title="{$event.event_end_date|crmDate}">
                    {$event.event_end_date|crmDate}
                    </abbr> 	
                {/if}
            {/if}
        </div>
		<div class="clear"></div>
	</div>
			    
	{if $isShowLocation}

        {if $location.address.1}
            <div class="crm-section event_address-section">
                <div class="label"><label>{ts}Location{/ts}</label></div>
                <div class="content">{$location.address.1.display|nl2br}</div>
                <div class="clear"></div>
            </div>
        {/if}

	    {if ( $event.is_map && $config->mapAPIKey && 
	        ( is_numeric($location.address.1.geo_code_1)  || 
	        ( $config->mapGeoCoding && $location.address.1.city AND $location.address.1.state_province ) ) ) }
	        <div class="crm-section event_map-section">
	            <div class="content">
                    {assign var=showDirectly value="1"}
                    {if $mapProvider eq 'Google'}
                        {include file="CRM/Contact/Form/Task/Map/Google.tpl" fields=$showDirectly}
                    {elseif $mapProvider eq 'Yahoo'}
                        {include file="CRM/Contact/Form/Task/Map/Yahoo.tpl"  fields=$showDirectly}
                    {/if}
                    <br /><a href="{$mapURL}" title="{ts}Show large map{/ts}">{ts}Show large map{/ts}</a>
	            </div>
	            <div class="clear"></div>
	        </div>
	    {/if}

	{/if}{*End of isShowLocation condition*}  


	{if $location.phone.1.phone || $location.email.1.email}
	    <div class="crm-section event_contact-section">
	        <div class="label"><label>{ts}Contact{/ts}</label></div>
	        <div class="content">
	            {* loop on any phones and emails for this event *}
	            {foreach from=$location.phone item=phone}
	                {if $phone.phone}
	                    {if $phone.phone_type}{$phone.phone_type_display}{else}{ts}Phone{/ts}{/if}: 
	                        <span class="tel">{$phone.phone}</span> <br />
	                    {/if}
	            {/foreach}
	
	            {foreach from=$location.email item=email}
	                {if $email.email}
	                    {ts}Email:{/ts} <span class="email"><a href="mailto:{$email.email}">{$email.email}</a></span>
	                {/if}
	            {/foreach}
	        </div>
	        <div class="clear"></div>
	    </div>
	{/if}

    {* Kabissa Redmine bug #540 *}
    {* remove fee section *}
	{* {if $event.is_monetary eq 1 && $feeBlock.value}
	    <div class="crm-section event_fees-section">
	        <div class="label"><label>{$event.fee_label}</label></div>
	        <div class="content">
	            <table class="form-layout-compressed fee_block-table">
	                {foreach from=$feeBlock.value name=fees item=value}
	                    {assign var=idx value=$smarty.foreach.fees.iteration}
	                    {if $feeBlock.lClass.$idx}
	                        {assign var="lClass" value=$feeBlock.lClass.$idx}
	                    {else}
	                        {assign var="lClass" value="fee_level-label"}
	                    {/if}
	                    <tr>
	                        <td class="{$lClass} crm-event-label">{$feeBlock.label.$idx}</td>
	                        <td class="fee_amount-value right">{$feeBlock.value.$idx|crmMoney}</td>
	                    </tr>
	                {/foreach}
	            </table>
	        </div>
	        <div class="clear"></div>
	    </div>
	{/if} *}
	{* end Kabissa Redmine bug #540 *}


    {include file="CRM/Custom/Page/CustomDataView.tpl"}
        
	{if $allowRegistration}
        <div class="action-link section register_link-section">
            <a href="{$registerURL}" title="{$registerText}" class="button crm-register-button"><span>{$registerText}</span></a>
        </div>
    {/if}
    { if $event.is_public }
        <br />{include file="CRM/Event/Page/iCalLinks.tpl"}
    {/if}


		{* Kabissa Redmine bug #442 *}
		{if $event.event_type_id EQ 7} 
			{*retrieve all participants of event*}
			{crmAPI var="eventPartipants" entity="Participant" action="get" version="3" event_id=$event.id }
			<fieldset id="priceset" class="crm-group priceset-group"><legend>Participants</legend>
				<div class="crm-container">
					<table>
						{foreach from=$eventPartipants.values item=Participant}
							{* Kabissa Redmine bug #513 *}
							{* retrieve participant role with api *}
							{assign var=roleID value=$Participant.participant_role_id}
							{crmAPI var="participantRole" entity="OptionValue" action="get" version="3" option_group_id="13" value=$roleID }
							{foreach from=$participantRole.values item=Role}
								{assign var=roleLabel value=$Role.label}
							{/foreach}	
							{* end Kabissa Redmine bug #513 *}
							
							<tr><td colspan='3'><hr></td></tr>				
							{* Display name and affiliated organization *}
							<tr>
								<td colspan='3'>
									{if $Participant.custom_33 ne ''}
										{$Participant.display_name}&nbsp;&#45;&nbsp;{$Participant.custom_33}
										{if $roleLabel ne ''}
											&nbsp;&#40;{$roleLabel}&#41;
										{/if}	
									{else}
										{$Participant.display_name}								
										{if $roleLabel ne ''}
											&nbsp;&#40;{$roleLabel}&#41;
										{/if}	
									{/if}
								</td>
							</tr>
							{* Display website if not empty *}
							{if $Participant.custom_32 ne ''}
								<tr>
									<th>Website</th>
									<td>:</td>
									<td><a href="{$Participant.custom_32}">{$Participant.custom_32}</a></td>
								</tr>
							{/if}		
							{* Display blog is not empty *}			
							{if $Participant.custom_35 ne ''}
								<tr>			
									<th>Blog</th>
									<td>:</td>
									<td><a href="{$Participant.custom_35}">{$Participant.custom_35}</a></td>
								</tr>
							{/if}		
							{* Display comments if not empty *}
							{if $Participant.custom_34 ne ''}
								<tr>			
									<th>Comments</th>
									<td>:</td>
									<td>{$Participant.custom_34}</td>
								</tr>
							{/if}		
						{/foreach}	
					</table>	
				</div>
			</fieldset>		
		{/if}
		{* end of Kabissa Redmine bug #442 *}   
    </div>
</div>
