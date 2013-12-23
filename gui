#-*- coding: utf-8 -*-

# ----- BREEDERS MANAGER V1.0 ------

import gtk, re,sqlalchemy
from datetime import datetime,date
from multiplication import MultiplicationWindow
from server_preferences import ServerPreferencesWindow
from notes import NotesWindow
from molts import MoltsWindow
from temp_hig import TempHigWindow
from error_windows import ErrorWindow
from info_windows import InformationWindows
from connection import FtpConnection

from databases_alchemy import SpeciesBase,Database
from databases_alchemy import db_name
from filter import Filter,Sort
from filter_window import FilterWindow
from license import License,lic_expires
from status import Status

class MainWindow():
    ''' class which handles main window GUI '''
    def __init__(self):
        self.gladefile = gtk.Builder()
        self.gladefile.add_from_file('main_interface.glade')
        self.gladefile.connect_signals(self)
        self.main_window = self.gladefile.get_object('main_window')
        self.species_tree = self.gladefile.get_object('species_list')
        self.species_tree_view = self.gladefile.get_object('species_tree')
        self.main_window.show_all()

        self.check_database()
        
# --------------------FIELDS--------------------
        self.id_entry = self.gladefile.get_object('id_entry')
        self.latin_name_entry = self.gladefile.get_object('latin_name_entry')
        self.buy_date_entry = self.gladefile.get_object('buy_date_entry')
        self.molt_entry = self.gladefile.get_object('molt_entry')
        self.body_length_entry = self.gladefile.get_object('body_length_entry')
        
        
        self.male_radio = self.gladefile.get_object('male_radio')
        self.female_radio = self.gladefile.get_object('female_radio')
        
        self.multiplication_yes_radio = self.gladefile.get_object('multiplication_yes_radio')
        self.multiplication_no_radio = self.gladefile.get_object('multiplication_no_radio')
        
        self.spider_state_alive_radio = self.gladefile.get_object('spider_state_alive_radio')
        self.spider_state_dead_radio = self.gladefile.get_object('spider_state_dead_radio')
        
        self.id_entry.set_max_length(10)
        self.latin_name_entry.set_max_length(30)
        self.buy_date_entry.set_max_length(10)
        self.molt_entry.set_max_length(3)
        self.body_length_entry.set_max_length(5)
        
        #filter
        self.expander = self.gladefile.get_object('expander')
        
        self.filter_basic_entry = self.gladefile.get_object('filter_basic_entry')
        self.filter_basic_entry.set_text('Szukaj..')
        
        self.f_latin_name_entry = self.gladefile.get_object('filter_l_name_entry')
        self.f_latin_name_entry.set_text('Nazwa łacińska..')
        self.f_molt_entry = self.gladefile.get_object('filter_molt_entry')
        self.f_molt_entry.set_text('Wylinka..')
        self.f_body_length_entry = self.gladefile.get_object('filter_b_length_entry')
        self.f_body_length_entry.set_text('Długość ciała..')
        self.f_buy_date_entry = self.gladefile.get_object('filter_b_date_entry')
        self.f_buy_date_entry.set_text('Data nabycia..')
        
        self.f_sex_male_radio = self.gladefile.get_object('filter_sex_male')
        self.f_sex_female_radio = self.gladefile.get_object('filter_sex_female')
        self.filter_sex_mode(False)
        self.f_check_sex_checkbox = self.gladefile.get_object('filter_check_sex')
        
        self.f_mult_yes_radio = self.gladefile.get_object('filter_mult_yes')
        self.f_mult_no_radio = self.gladefile.get_object('filter_mult_no')
        self.filter_mult_mode(False)
        self.f_check_mult_checkbox = self.gladefile.get_object('filter_check_mult')
        
        self.lower_than_molt_radio = self.gladefile.get_object('filter_lower_than_molt')
        self.bigger_than_molt_radio = self.gladefile.get_object('filter_bigger_than_molt')
        self.equal_to_molt_radio = self.gladefile.get_object('filter_equal_to_molt')
        self.filter_molt_mode(False)
        self.f_check_molt_checkbox = self.gladefile.get_object('filter_check_molt')
        
        self.lower_than_body_length_radio = self.gladefile.get_object('filter_lower_than_b_len')
        self.bigger_than_body_length_radio = self.gladefile.get_object('filter_bigger_than_b_len')
        self.equal_to_body_length_radio = self.gladefile.get_object('filter_equal_to_b_len')
        self.filter_body_length_mode(False)
        self.f_check_body_length_checkbox = self.gladefile.get_object('filter_check_b_length')
        
        self.before_date_radio = self.gladefile.get_object('filter_before_date')
        self.after_date_radio = self.gladefile.get_object('filter_after_date')
        self.equal_to_date_radio = self.gladefile.get_object('filter_equal_to_date')
        self.filter_buy_date_mode(False)
        self.f_check_buy_date_checkbox = self.gladefile.get_object('filter_check_b_date')
        #sort
        self.s_latin_name_check = self.gladefile.get_object('sort_by_l_name')
        self.s_molt_check = self.gladefile.get_object('sort_by_molt')
        self.s_body_length_check = self.gladefile.get_object('sort_by_b_len')
        self.s_buy_date_check = self.gladefile.get_object('sort_by_b_date')
        self.s_sex_check = self.gladefile.get_object('sort_by_sex')
        self.s_multiplication_check = self.gladefile.get_object('sort_by_mult')
        self.sort_mode_asc_radio = self.gladefile.get_object('sort_ascending')
        self.sort_mode_desc_radio = self.gladefile.get_object('sort_descending')
        
        #statusbar
        self.status_bar = self.gladefile.get_object('statusbar1')
        code, status = Status().compose()
        self.status_bar.push(code, status)
#         print Status().compose()
        
        #license
        l = License().check_licence()
        if l == 2:
            pass
        elif l == 1:
            InformationWindows().show_license_activated_dialog(lic_expires)
        elif l == -3:
            ErrorWindow().show_license_expired_dialog()    
        elif l == -2:
            ErrorWindow().show_license_connection_failed_dialog()
        elif l == -1:
            ErrorWindow().show_license_unactive_dialog()
        
#         FilterWindow().show()
# --------------------EVENTS--------------------
    
    def on_main_window_destroy(self, widget):
        ''' function which destroys main window '''
        gtk.main_quit()
        
    def on_species_tree_cursor_changed(self,widget):
        ''' event which activates when single click on row is made, return selected row which is common in view and database '''
        selection = widget.get_selection()
        (model,iterator) = selection.get_selected()
        row = []
        for i in xrange(8): # row has 7 columns
            try:
                row.append(model[iterator][i])
            except TypeError:
                return None
        return row
    
    # main choose menu
    def on_multiplication_button_clicked(self, widget):
        ''' function which calls Multiplication Window '''
        self.clear_entry()
        selection = self.species_tree_view.get_selection()
        (model,iterator) = selection.get_selected()
        try:
            idn = model[iterator][0]
            s_name = model[iterator][1]
            s_sex = model[iterator][2]
            s_mult = model[iterator][3]
            if s_mult == 'Tak':
                if s_sex != 'Samiec':
                    MultiplicationWindow(idn).show(s_name, s_sex)
                else:
                    ErrorWindow().show_sex_error_dialog()
            else:
                ErrorWindow().show_multiplication_error_dialog()
        except TypeError:
            ErrorWindow().show_no_specie_choosed_error_dialog()
        
    def on_molt_button_clicked(self, widget):
        self.clear_entry()
        ''' function which calls Molts Window '''
        selection = self.species_tree_view.get_selection()
        (model,iterator) = selection.get_selected()
        try:
            idn = model[iterator][0]
            s_name = model[iterator][1]
            s_sex = model[iterator][2]
            MoltsWindow(idn).show(s_name, s_sex)
        except TypeError:
            ErrorWindow().show_no_specie_choosed_error_dialog() 
        
    def on_notes_button_clicked(self, widget):
        self.clear_entry()
        ''' function which calls Notes Window '''
        selection = self.species_tree_view.get_selection()
        (model,iterator) = selection.get_selected()
        try:
            idn = model[iterator][0]
            s_name = model[iterator][1]
            s_sex = model[iterator][2]
            NotesWindow(idn).show(s_name,s_sex)
        except TypeError:
            ErrorWindow().show_no_specie_choosed_error_dialog() 
        
        
    def on_temp_hig_button_clicked(self, widget):
        self.clear_entry()
        ''' function which calls Temperature and Humidity Window '''
        selection = self.species_tree_view.get_selection()
        (model,iterator) = selection.get_selected()
        try:
            idn = model[iterator][0]
            s_name = model[iterator][1]
            s_sex = model[iterator][2]
            TempHigWindow(idn).show(s_name,s_sex)
        except TypeError:
            ErrorWindow().show_no_specie_choosed_error_dialog() 
    
    def on_extended_filter_button_clicked(self,widget):
        self.clear_entry()
        FilterWindow(self).show()
    
    #main choose menu second row
    def on_view_refresh_item_activate(self,widget):
        ''' button that refreshes species list '''
        try:
            self.species_tree.clear()
            self.load_species_from_db()
        except:
            pass
        
    # second row of buttons
    def on_add_species_button_clicked(self,widget):
        ''' button which add row to list of species '''
        data = self.check_species_input() 
        if data == False:
            ErrorWindow().show_input_error()
        else:
            try:
                specie = SpeciesBase() 
                specie.add_species(data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7])
                self.species_tree.append(self.convert_data_to_view(data))
                self.clear_entry()
            except sqlalchemy.exc.IntegrityError:
                specie.session.rollback()
                ErrorWindow().show_id_duplicate_dialog()
        
    def on_delete_species_button_clicked(self,widget):
        self.clear_entry()
        ''' button which delete from list of species '''
        selection = self.species_tree_view.get_selection()
        (model,iterator) = selection.get_selected()
        try :
            idn = model[iterator][0]
            self.species_tree.remove(iterator)
            #print 'delete species id',idn
            SpeciesBase().delete_row_by_id(idn)
        except TypeError:
            ErrorWindow().show_null_selection_error()
        
    
    def on_edit_species_clicked(self,widget):
        ''' button which edit species row in list of species'''
        try:
            row = self.on_species_tree_cursor_changed(self.species_tree_view)
            self.fill_entry(row)
        except TypeError:
            ErrorWindow().show_null_selection_error()
    
    def on_accept_row_changes_button_clicked(self,widget):
        ''' button which applies changes made to edited row '''
        selection = self.species_tree_view.get_selection()
        (_,iterator) = selection.get_selected()
        
        data = self.check_species_input() 
        if data == False:
            ErrorWindow().show_input_error()
        else:
            SpeciesBase().edit_row_by_id(data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7])
            self.species_tree[iterator] = self.convert_data_to_view(data)
            self.clear_entry()
    
    #upper menu 'safety'
    def  on_import_base_item_activate(self,widget):
        ''' import base from server specified in ServerPreferencesWindow by ftp '''
        data = ServerPreferencesWindow().read_from_file()
        msg = FtpConnection().download_database(data)
        if msg == 1:
            InformationWindows().show_base_succesfully_downloaded()
        elif msg == 0:
            ErrorWindow().show_wrong_server_settings_or_db_not_in_server()
        else:
            ErrorWindow().show_connection_failed()
        
    def on_export_base_item_activate(self,widget):
        ''' exports base to server specified in ServerPreferencesWindow by ftp '''
        data = ServerPreferencesWindow().read_from_file()
        msg = FtpConnection().upload_database(data)
        if msg == 1:
            InformationWindows().show_base_succesfully_uploaded()
        elif msg == 0:
            ErrorWindow().show_wrong_server_settings()
        else:
            ErrorWindow().show_connection_failed()
        
    def on_server_preferences_item_activate(self,widget):
        ''' function which calls ServerPreferences Window  '''
        ServerPreferencesWindow().show()
    
    #upper menu file
    def on_save_base_as_item_activate(self,widget):
        ''' saves base to specified location,and gives new name to database which contains current date '''
        date_name = str(date.today()).split('-')
        name = db_name.split('.')
        current_db_name = name[0]+'_'+'_'.join(date_name)+'.'+name[1]
        InformationWindows().show_save_as_dialog(current_db_name)
        
    def on_open_file_item_activate(self,widget):
        ''' opens file chooser window, to choose location of database to import'''
        InformationWindows().show_open_file_dialog()
    
    #filter
    def on_expander_activate(self,widget):
        '''function that activates when extended filter is opened or closed '''
        if not self.expander.get_expanded():
            self.f_latin_name_entry.set_text('Nazwa łacińska..')
            
    def on_filter_button_clicked(self,widget):
        '''function that calls filter_overall, activates when filter button is clicked '''
        text = self.filter_basic_entry.get_text().decode('UTF-8')
        if text != '':
            self.filter_overall()
        else:
            self.species_tree.clear()
            self.load_species_from_db()
    
    def on_filter_basic_entry_activate(self,widget):
        ''' function that calls filter_overall, activates when enter is pressed in filter entry'''
        text = self.filter_basic_entry.get_text().decode('UTF-8')
        if text != '':
            self.filter_overall()
        else:
            self.species_tree.clear()
            self.load_species_from_db()
            
    def filter_overall(self):
        ''' function than handles basic filtering, it clears tree view and loads filtered content '''
        text = self.filter_basic_entry.get_text().decode('UTF-8')
        search_res = Filter().search_overall(text)
        self.species_tree.clear()
        for row in [elem.get_tuple() for elem in search_res]:
            self.species_tree.append(self.convert_data_to_view(row))

    def on_filter_entry_button_press_event(self,a,w):
        ''' function that clears basic filter entry when,left mouse button is clicked on it '''
        text = self.filter_basic_entry.get_text().decode('UTF-8')
        if text == 'Szukaj..':
            self.filter_basic_entry.set_text('')
    
    def filter_sex_mode(self,mode=False):
        ''' filter that enables/disables sex option in filter '''
        self.f_sex_male_radio.set_sensitive(mode)
        self.f_sex_female_radio.set_active(True)
        self.f_sex_female_radio.set_sensitive(mode)
    
    def on_filter_check_sex_toggled(self,widget):
        ''' function that calls sex_mode to enable/disable sex option when its marked/unmarked '''
        self.filter_sex_mode(self.f_check_sex_checkbox.get_active())
    
    def filter_mult_mode(self,mode=False):
        ''' filter that enables/disables multiplication option in filter '''
        self.f_mult_yes_radio.set_active(True)
        self.f_mult_yes_radio.set_sensitive(mode)
        self.f_mult_no_radio.set_sensitive(mode)
        
    def on_filter_check_mult_toggled(self,widget):
        ''' function that calls sex_mode to enable/disable multiplication option when its marked/unmarked '''
        self.filter_mult_mode(self.f_check_mult_checkbox.get_active())
                    
    def filter_molt_mode(self,mode=False):
        ''' filter that enables/disables molt option in filter '''
        self.f_molt_entry.set_sensitive(mode)
        self.lower_than_molt_radio.set_sensitive(mode)
        self.bigger_than_molt_radio.set_sensitive(mode)
        self.equal_to_molt_radio.set_active(True)
        self.equal_to_molt_radio.set_sensitive(mode)
        if mode == False:
            self.f_molt_entry.set_text('Wylinka..')
        
    def on_filter_check_molt_toggled(self,widget):
        ''' function that calls sex_mode to enable/disable molt option when its marked/unmarked '''
        self.filter_molt_mode(self.f_check_molt_checkbox.get_active())
        
    def on_filter_molt_entry_activate(self,widget):
        ''' function that calls filter_precisely when enter is pressed on molt entry '''
        self.filter_precisely()

    def on_filter_molt_entry_button_press_event(self,a,w):
        ''' function that clears filter molt entry when,left mouse button is clicked on it '''
        text = self.f_molt_entry.get_text().decode('UTF-8')
        if text == 'Wylinka..':
            self.f_molt_entry.set_text('')
           
    def filter_body_length_mode(self,mode=False):
        ''' filter that enables/disables body_length option in filter '''
        self.f_body_length_entry.set_sensitive(mode)
        self.lower_than_body_length_radio.set_sensitive(mode)
        self.bigger_than_body_length_radio.set_sensitive(mode)
        self.equal_to_body_length_radio.set_active(True)
        self.equal_to_body_length_radio.set_sensitive(mode)
        if mode == False:
            self.f_body_length_entry.set_text('Długość ciała..')
        
    def on_filter_check_b_length_toggled(self,widget):
        ''' function that calls sex_mode to enable/disable body_length option when its marked/unmarked '''
        self.filter_body_length_mode(self.f_check_body_length_checkbox.get_active())
        
    def on_filter_b_length_entry_activate(self,widget):
        ''' function that calls filter_precisely when enter is pressed on body_length entry '''
        self.filter_precisely()
    
    def on_filter_b_length_entry_button_press_event(self,a,w):
        ''' function that clears filter body_length entry when,left mouse button is clicked on it '''
        text = self.f_body_length_entry.get_text().decode('UTF-8')
        if text == 'Długość ciała..':
            self.f_body_length_entry.set_text('')
            
    def filter_buy_date_mode(self,mode=False):
        ''' filter that enables/disables buy_date option in filter '''
        self.f_buy_date_entry.set_sensitive(mode)
        self.before_date_radio.set_sensitive(mode)
        self.after_date_radio.set_sensitive(mode)
        self.equal_to_date_radio.set_active(True)
        self.equal_to_date_radio.set_sensitive(mode)
        if mode == False:
            self.f_buy_date_entry.set_text('Data nabycia..')
        
    def on_filter_check_b_date_toggled(self,widget):
        ''' function that calls sex_mode to enable/disable buy_date option when its marked/unmarked '''
        self.filter_buy_date_mode(self.f_check_buy_date_checkbox.get_active())
        
    def on_filter_b_date_entry_activate(self,widget):
        ''' function that calls filter_precisely when enter is pressed on buy_date entry '''
        self.filter_precisely()
    
    def on_filter_b_date_entry_button_press_event(self,a,w):
        ''' function that clears filter buy_date entry when,left mouse button is clicked on it '''
        text = self.f_buy_date_entry.get_text().decode('UTF-8')
        if text == 'Data nabycia..':
            self.f_buy_date_entry.set_text('')
            
    def on_filter_clear_button_clicked(self,widget):
        ''' clears filter entries '''
        self.f_latin_name_entry.set_text('Nazwa łacińska..')
        self.filter_molt_mode(False)
        self.filter_body_length_mode(False)
        self.filter_buy_date_mode(False)
        self.filter_sex_mode(False)
        self.filter_mult_mode(False)
        
    def on_filter_l_name_entry_activate(self,widget):
        ''' function that calls filter_precisely when enter is pressed on latin_name entry '''
        self.filter_precisely()
    
    def on_filter_l_name_entry_button_press_event(self,a,w):
        ''' function that clears filter latin_name entry when,left mouse button is clicked on it '''
        text = self.f_latin_name_entry.get_text().decode('UTF-8')
        if text == 'Nazwa łacińska..':
            self.f_latin_name_entry.set_text('')
                
    def on_filter_extended_button_clicked(self,widget):
        ''' function that calls filter_precisely when extended filtering button is clicked'''
        self.filter_precisely()
    
    def filter_precisely(self):
        ''' function that handles extended filtering process, if clears treeview and loads filtered content '''
        search_res = Filter().search_precisely(self.get_filtering_fields()).all()
        self.species_tree.clear()
        for row in [elem.get_tuple() for elem in search_res]:
            self.species_tree.append(self.convert_data_to_view(row))

    def get_filtering_fields(self):
        ''' function gets sorting information from checkboxes, returns filtering options.
        Possible filtering options: molt, body_length, buy_date, sex, multiplication'''
        mode = []
        
        latin_name = self.f_latin_name_entry.get_text()
        if latin_name != 'Nazwa łacińska..' and latin_name != '':
            mode.append(('latin_name',1,latin_name))
            
        molt_content = self.f_molt_entry.get_text()
        if molt_content == 'Wylinka..':
            molt_content = ''
            
        body_length_content = self.f_body_length_entry.get_text().decode('UTF-8')
        if body_length_content =='Długość ciała..':
            body_length_content = ''
            
        buy_date_content = self.f_buy_date_entry.get_text().decode('UTF-8')
        if buy_date_content == 'Data nabycia..':
            buy_date_content = ''
        if self.f_check_molt_checkbox.get_active():
            mode.append(('molt',self.get_molt_filtering_option(),molt_content))
        if self.f_check_body_length_checkbox.get_active():
            mode.append(('body_length',self.get_body_length_filtering_option(),body_length_content))
        if self.f_check_buy_date_checkbox.get_active():
            mode.append(('buy_date',self.get_buy_date_filtering_option(),buy_date_content))
        if self.f_check_sex_checkbox.get_active():
            mode.append(('sex',self.get_sex_filtering_option()))
        if self.f_check_mult_checkbox.get_active():
            mode.append(('multiplication',self.get_multiplication_filtering_option()))

        return mode
    
    def get_molt_filtering_option(self):
        ''' function that returns filtering option 
        0-lower than, 1-equal to, 2-bigger than '''
        if self.lower_than_molt_radio.get_active():
            return -1
        elif self.equal_to_molt_radio.get_active():
            return 0
        elif self.bigger_than_molt_radio.get_active():
            return 1
    
    def get_body_length_filtering_option(self):
        ''' function that returns filtering option 
        0-lower than, 1-equal to, 2-bigger than '''
        if self.lower_than_body_length_radio.get_active():
            return -1
        elif self.equal_to_body_length_radio.get_active():
            return 0
        elif self.bigger_than_body_length_radio.get_active():
            return 1
        
    def get_buy_date_filtering_option(self):
        ''' function that returns filtering option 
        0-before date, 1-equal to date, 2-after date '''
        if self.before_date_radio.get_active():
            return -1
        elif self.equal_to_date_radio.get_active():
            return 0
        elif self.after_date_radio.get_active():
            return 1
    
    def get_sex_filtering_option(self):
        ''' function that returns filtering option 
        True - male /False - female '''
        return self.f_sex_male_radio.get_active()    
    
    def get_multiplication_filtering_option(self):
        ''' function that returns filtering option 
        True - yes /False - no '''
        return self.f_mult_yes_radio.get_active()
    
    #sort
    def on_sort_data_button_clicked(self,widget):
        ''' calls get_sorting_fields to get sorting parameters, and get_sorting_mode to get ascending/descending option, uses Sort() class to sort data
        ,clears treeview and loads sorted data '''
        try:
            table = Sort().sort(self.get_sorting_fields(), self.get_sorting_mode(), self.get_filtering_fields()).all()
            self.species_tree.clear()
            for row in [ item.get_tuple() for item in table]:
                self.species_tree.append(self.convert_data_to_view(row))
        except:
            self.species_tree.clear()
            self.load_species_from_db()
        
    def get_sorting_fields(self):
        ''' gets sorting information from checkboxes, returns sorting options.
        Possible sorting options: 1-latin_name, 2-sex, 3-multiplication, 4-body_length, 5-molt, 6-buy_date. '''
        mode = []
        if self.s_latin_name_check.get_active():
            mode.append('latin_name')
        if self.s_sex_check.get_active():
            mode.append('sex')
        if self.s_multiplication_check.get_active():
            mode.append('multiplication')
        if self.s_body_length_check.get_active():
            mode.append('body_length')
        if self.s_molt_check.get_active():
            mode.append('molt')
        if self.s_buy_date_check.get_active():
            mode.append('buy_date')
        return mode
    
    def get_sorting_mode(self):
        ''' gets sorting mode from radio button, returns True when data should be sorted ascending or False otherwise. '''
        return self.sort_mode_asc_radio.get_active()
            
# --------------------OTHER FUNCTIONS--------------------    
    
    def check_database(self):
        ''' function that checks whether there is database on local machine or not, 
        if is not and server preferences are set, it asks user to download it from server '''
        login_data = ServerPreferencesWindow().read_from_file()
        if Database().check_base_existance():
            self.load_species_from_db()
        else:
            ErrorWindow().show_base_not_found_error(login_data)

            
    def load_species_from_db(self):
        ''' function which loads data from database '''
        table = SpeciesBase().get_species_table()
        for row in table:
            self.species_tree.append(self.convert_data_to_view(row))
    
    def check_species_input(self):
        ''' function which checks user input format, returns data in apripirate database format
        id - integer, latin_name - string,
         body_length must have format 2x'digit' or (2x'digit')+cm, example: 5 , 5cm
         molt must have format 'digit' or 'L' or 'l' + 'digit', example: L5, l12
         byt_date must have format YYYY-MM-DD, example: 2012-10-10 '''
        try:
            idn = int(self.id_entry.get_text())
        except ValueError:
            return False
        
        latin_name = self.latin_name_entry.get_text()
        sex = self.check_sex_radio()
        spider_state = self.check_spider_state_radio()
        if spider_state:
            self.spider_state_alive_radio.set_active(True)
        if sex:
            self.multiplication_no_radio.set_active(True)
            
        multiplication = self.check_multiplication_radio()
        
        body_length = self.body_length_entry.get_text()
        molt = self.molt_entry.get_text()
        buy_date = str(self.buy_date_entry.get_text())
        
        if self.check_body_length_input(body_length):
            body_length = body_length[:-2]
        elif self.is_digit(body_length) != True:
            return False
            
        if self.check_molt_input(molt):
            molt = molt[1]
        elif self.is_digit(molt) != True:
            return False
        
        if buy_date != '':
            if self.check_date_input(buy_date) != True:
                return False
        else:
            buy_date = '----'
            
        data = [idn, latin_name, sex, multiplication, body_length, molt, buy_date, spider_state]
        return data
    
    def clear_entry(self):
        ''' function which clears entry fields ''' 
        self.id_entry.set_text('')
        self.latin_name_entry.set_text('')
        self.body_length_entry.set_text('')
        self.molt_entry.set_text('')
        self.buy_date_entry.set_text('')
    
    def fill_entry(self,row):
        ''' function that fills entry fields with values '''
        self.id_entry.set_text(str(row[0]))
        self.latin_name_entry.set_text(row[1])
        sex = row[2]
        mult = row[3]
        self.body_length_entry.set_text(row[4])
        self.molt_entry.set_text(row[5])
        if row[6] != '----':
            self.buy_date_entry.set_text(row[6])
        else:
            self.buy_date_entry.set_text('')
        
        if sex == 'Samica':
            self.female_radio.set_active(True)
        else:
            self.male_radio.set_active(True)
            
        if mult == 'Tak':
            self.multiplication_yes_radio.set_active(True)
        else:
            self.multiplication_no_radio.set_active(True)
        
        if row[7] == '+':
            self.spider_state_alive_radio.set_active(True)
        else:
            self.spider_state_dead_radio.set_active(True)
            
        
    def check_body_length_input(self,word):
        ''' function that checks if word has "digit digit cm" pattern '''
        ex = re.compile('^\d{1,2}cm|^\d\.\dcm$')
        if re.match(ex, str(word)):
            return True
        else:
            return False
    
    def check_molt_input(self,word):
        ''' function that checks if word has "L digit digit" pattern '''
        ex = re.compile('^[l,L]\d{1,2}$')
        if re.match(ex, str(word)):
            return True
        else:
            return False
    
    def is_digit(self,word):
        ''' function that checks if word is two digit number '''
        ex = re.compile('^\d{1,2}$')
        if re.match(ex, str(word)):
            return True
        else:
            return False
    
    def check_date_input(self,date):
        ''' function which checks if date is in YYYY-MM-DD format '''
        try:
            datetime.strptime(date,'%Y-%m-%d')
            return True
        except ValueError:
            return False
        
    def convert_data_to_view(self,data):
        ''' function that converts fields: sex,multiplication,body_length,molt, which are stored as integers in database, to readable form '''
        if data[2] == 1:
            sex = 'Samiec'
        else:
            sex = 'Samica'
        if data[3] == 1:
            multiplication = 'Tak'
        else:
            multiplication = 'Nie'
        body_length = str(data[4])+'cm'
        molt = 'L'+str(data[5])
        if data[7] == 1:
            state = '+'
        else:
            state = '--'
        return [data[0], data[1], sex, multiplication, body_length, molt, data[6],state]
    
    def check_spider_state_radio(self):
        if self.spider_state_alive_radio.get_active() == True:
            return 1
        else:
            return 0

    def check_sex_radio(self):
        ''' function which checks state of the species sex radio  '''
        if self.male_radio.get_active() == True:
            return 1
        else:
            return 0
        
    def check_multiplication_radio(self):
        ''' function which checks state of the species multiplication radio  '''
        if self.multiplication_yes_radio.get_active() == True:
            return 1
        else:
            return 0
        
if __name__ == '__main__':
    MainWindow()
    gtk.main()
