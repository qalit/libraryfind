# $Id: collection_controller.rb 1239 2008-03-13 16:55:13Z herlockt $

# LibraryFind - Quality find done better.
# Copyright (C) 2007 Oregon State University
#
# This program is free software; you can redistribute it and/or modify it under 
# the terms of the GNU General Public License as published by the Free Software 
# Foundation; either version 2 of the License, or (at your option) any later 
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT 
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with 
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple 
# Place, Suite 330, Boston, MA 02111-1307 USA
#
# Questions or comments on this program may be addressed to:
#
# LibraryFind
# 121 The Valley Library
# Corvallis OR 97331-4501
#
# http://libraryfind.org

class Admin::CollectionController < ApplicationController
  include ApplicationHelper

  layout 'libraryfind'
  before_filter :authorize, :except => 'login',
    :role => 'administrator', 
    :msg => 'Access to this page is restricted.'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => "post", :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @collection_pages, @collections = paginate :collections, :per_page => 20, 
      :order => 'alt_name asc'
    @display_columns = ['alt_name', 'name', 'record_schema']
  end

  def show
    @collection = Collection.find(params[:id])
  end

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new(params[:collection])
    if @collection.save
      flash[:notice] = translate('COLLECTION_CREATED')
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @collection = Collection.find(params[:id])
  end

  def test
    @collection = Collection.find(params[:id])
  end

  def update
    @collection = Collection.find(params[:id])
    if @collection.update_attributes(params[:collection])
      flash[:notice] = translate('COLLECTION_UPDATED')
      redirect_to :action => 'show', :id => @collection
    else
      render :action => 'edit'
    end
  end

  def destroy
    Collection.find(params[:id]).destroy
    if params[:id] != ''
      CollectionGroupMember.delete_all( "collection_id=" + params[:id].dump)
    end
    redirect_to :action => 'list'
  end
end
