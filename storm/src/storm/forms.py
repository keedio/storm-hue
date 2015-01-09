# -*- coding: utf-8 -*-

# Licensed to Cloudera, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Cloudera, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from django import forms
from django.forms import FileField, CharField, BooleanField, Textarea
from django.forms.formsets import formset_factory, BaseFormSet, ManagementForm

from desktop.lib import i18n
from hadoop.fs import normpath
from django.contrib.auth.models import User, Group

from django.utils.translation import ugettext_lazy as _

import logging
logger = logging.getLogger(__name__)

class PathField(CharField):
  def __init__(self, label, help_text=None, **kwargs):
    kwargs.setdefault('required', True)
    kwargs.setdefault('min_length', 1)
    forms.CharField.__init__(self, label=label, help_text=help_text, **kwargs)

  def clean(self, value):
    return normpath(CharField.clean(self, value))
  
class UploadFileForm(forms.Form):
  op = "upload"
  # The "hdfs" prefix in "hdfs_file" triggers the HDFSfileUploadHandler
  topology_name = CharField(label=_("Topology Name"), min_length=5, required=True)
  class_name = CharField(label=_("Class Name"), min_length=5, required=True)
  hdfs_file = FileField(forms.Form, label=_("File to Upload"))  
    
  #Validation. Topology Name between 5 and 100
  def clean_topology_name(self):
     dict = self.cleaned_data
     topology_name = dict.get('topology_name')     

     if (len(topology_name) < 5) or (len(topology_name) > 100):
        raise forms.ValidationError("Topology Name between 5 and 100 characters")
 
     return topology_name
  
  #Validation. Class Name between 5 and 100
  def clean_class_name(self):
     dict = self.cleaned_data
     class_name = dict.get('class_name')

     if (len(class_name) < 5) or (len(class_name) > 100):
        raise forms.ValidationError("Class Name between 5 and 100 characters")
 
     return class_name