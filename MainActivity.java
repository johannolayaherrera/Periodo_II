package com.example.jcanas.helpdesk;


import android.content.Context;
import android.os.Handler;
import android.os.StrictMode;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;

import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.BaseExpandableListAdapter;
import android.widget.EditText;
import android.widget.ExpandableListAdapter;
import android.widget.SimpleExpandableListAdapter;
import android.widget.Spinner;
import android.widget.SpinnerAdapter;
import android.widget.TextView;
import android.widget.Toast;

import android.widget.ExpandableListView;
import android.widget.ExpandableListView.OnChildClickListener;
import android.widget.ExpandableListView.OnGroupClickListener;
import android.widget.ExpandableListView.OnGroupCollapseListener;
import android.widget.ExpandableListView.OnGroupExpandListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;


public class MainActivity extends AppCompatActivity {

    private static final String SOAP_ACTION = "http://tempuri.org/IHelpDesk/GetCasos";
    private static final String METHOD_NAME = "GetCasos";
    private static final String NAMESPACE = "http://tempuri.org/";
    private static final String URL = "http://servidor.com/Servicio.svc";
    final HttpTransportSE transporte = new HttpTransportSE(URL);

    private Handler handler = new Handler();
    String res;
    private Thread thread;
    TextView tvwResultado;
    EditText etxtNtUser, etxtIdEstado;
    Spinner spinUsuario, spinEstado;
    Context context = this;

    //Objetos listView Expandable
    ExpandableListAdapterJ listAdapter;
    ExpandableListView expListView;
    List<String> listDataHeader;
    HashMap<String, List<String>> listDataChild;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvwResultado = (TextView) findViewById(R.id.tvwResultado);
        etxtNtUser = (EditText) findViewById(R.id.etxtUsuario);
        //etxtIdEstado = (EditText) findViewById(R.id.etxtEstado);
        //spinUsuario = (Spinner) findViewById(R.id.spinnerUsuario);
        spinEstado = (Spinner) findViewById(R.id.spinnerEstado);
        expListView = (ExpandableListView) findViewById(R.id.expandableListView);
        //GetUsuarios();
        GetEstados();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
    public void GetUsuarios(){
        try {
            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
            StrictMode.setThreadPolicy(policy);

            SoapObject Request = new SoapObject(NAMESPACE, "GetUsuariosAtienden");
            SoapSerializationEnvelope soapEnvelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
            soapEnvelope.dotNet = true;
            soapEnvelope.setOutputSoapObject(Request);
            transporte.call("http://tempuri.org/IHelpDesk/GetUsuariosAtienden", soapEnvelope);
            String nt="";
            String miUsuario="";
            final SoapObject resultSoap = (SoapObject) soapEnvelope.getResponse();
            List<String> lstUsuarios = new ArrayList<String>();
            for (int i = 0 ; i<resultSoap.getPropertyCount(); i++) {
                if (resultSoap.hasProperty("GetNTAtencion_Result")) {
                    SoapObject soapObject1 = (SoapObject) resultSoap.getProperty(i);
                    if (soapObject1.hasProperty("nt_user")) {
                        nt = soapObject1.getProperty("nt_user").toString();
                        miUsuario = soapObject1.getProperty("usuario").toString();
                        lstUsuarios.add(nt);
                    }
                }
            }
            // Creating adapter for spinner
            ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, lstUsuarios);
            // Drop down layout style - list view with radio button
            //dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            // attaching data adapter to spinner
            spinUsuario.setAdapter(dataAdapter);
        }
        catch (Exception ex) {
            tvwResultado.setText(ex.getMessage().toString());
        }
    }
    public void GetEstados(){
        try{
            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
            StrictMode.setThreadPolicy(policy);

            SoapObject Request = new SoapObject(NAMESPACE, "GetEstados");
            SoapSerializationEnvelope soapEnvelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
            soapEnvelope.dotNet = true;
            soapEnvelope.setOutputSoapObject(Request);
            transporte.call("http://tempuri.org/IHelpDesk/GetEstados", soapEnvelope);
            String id_estado="";
            String estado="";
            final SoapObject resultSoap = (SoapObject) soapEnvelope.getResponse();
            //List<String> lstEstados = new ArrayList<String>();
            ClsEstadosTck[] lstClsEstadosTck = new ClsEstadosTck[resultSoap.getPropertyCount()];

            for (int i = 0 ; i<resultSoap.getPropertyCount(); i++) {
                if (resultSoap.hasProperty("GetEstados_Result")) {
                    SoapObject soapObject1 = (SoapObject) resultSoap.getProperty(i);
                    if (soapObject1.hasProperty("id_estado")) {
                        id_estado = soapObject1.getProperty("id_estado").toString();
                        estado = soapObject1.getProperty("estado").toString();
                        //lstEstados.add(id_estado);
                        ClsEstadosTck clsEstadosTck = new ClsEstadosTck(id_estado,estado);
                        lstClsEstadosTck[i]=clsEstadosTck;
                    }
                }
            }
            // Creating adapter for spinner
            //ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, lstEstados);
            // attaching data adapter to spinner
            //spinEstado.setAdapter(dataAdapter);
            ArrayAdapter spinnerArrayAdapter = new ArrayAdapter(this,android.R.layout.simple_spinner_item,lstClsEstadosTck);
            spinEstado.setAdapter(spinnerArrayAdapter);
        }
        catch (Exception ex) {
            tvwResultado.setText(ex.getMessage().toString());
        }
    }
    public void btnConsultar_Click(View v){

        try {
            String ntUser = etxtNtUser.getText().toString();
            //String miEstado = etxtIdEstado.getText().toString();
            //String ntUser = spinUsuario.getSelectedItem().toString();
            ClsEstadosTck clsEstadosTck = (ClsEstadosTck)spinEstado.getSelectedItem();
            //String miEstado = spinEstado.getSelectedItem().toString();
            String miEstado = clsEstadosTck.idEstado;

            if(ntUser.isEmpty() || miEstado.isEmpty()){
                Toast tMensaje = Toast.makeText(getApplicationContext(), "Debe completar todos los campos", Toast.LENGTH_SHORT);
                tMensaje.show();
                return;
            }
            else {
                long idEstado = Long.parseLong(miEstado);
                ConsultarTickets(ntUser, idEstado);
                //thread.interrupt();
                //tvwResultado.setText(tvwResultado.getText() + " FIN");
                listAdapter = new ExpandableListAdapterJ(this, listDataHeader, listDataChild);
                //setting list adapter
                expListView.setAdapter(listAdapter);
            }
        }
        catch (Exception ex){
            tvwResultado.setText(ex.getMessage().toString());
        }
    }
    public void ConsultarTickets(final String ntUser, final long idEstado){
        //thread = new Thread(){
            //public void run(){
                try {
                    StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
                    StrictMode.setThreadPolicy(policy);

                    SoapObject Request = new SoapObject(NAMESPACE, "GetCasos");
                    Request.addProperty("nt", ntUser);
                    Request.addProperty("idEstado", idEstado);

                    SoapSerializationEnvelope soapEnvelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
                    soapEnvelope.dotNet = true;
                    soapEnvelope.setOutputSoapObject(Request);
                    transporte.call(SOAP_ACTION, soapEnvelope);

                    final SoapObject resultSoap = (SoapObject) soapEnvelope.getResponse();
                    //------------
                    listDataHeader = new ArrayList<String>();
                    listDataChild = new HashMap<String, List<String>>();
                    //------------
                    String ticketsJ = "";
                    String miTicket = "";
                    for (int i = 0 ; i<resultSoap.getPropertyCount(); i++){
                        if (resultSoap.hasProperty("GetCasosPendientes_Result")) {
                            SoapObject soapObject1 = (SoapObject) resultSoap.getProperty(i);
                            if (soapObject1.hasProperty("Aplicacion")) {
                                miTicket = soapObject1.getProperty("Ticket").toString();
                                listDataHeader.add(miTicket);
                                List<String> lstDetalles = new ArrayList<String>();
                                lstDetalles.add(soapObject1.getProperty("Solicitud").toString());
                                lstDetalles.add(soapObject1.getProperty("Solicitante").toString());
                                lstDetalles.add(soapObject1.getProperty("Aplicacion").toString());
                                lstDetalles.add(soapObject1.getProperty("Estado").toString());
                                lstDetalles.add(soapObject1.getProperty("FechaCreacion").toString());
                                listDataChild.put(listDataHeader.get(i), lstDetalles); // Header, Child data
                            }
                        }
                    }
                    //res = "";//" Apps: " + ticketsJ;
                    //tvwResultado.setText("" + ticketsJ);
                }
                catch(Exception e){
                    res = e.getMessage().toString();
                }
                //handler.post(createUI);
            //}
        //};
       // thread.start();
    }
    /*public void ConsultarTickets(final String ntUser, final long idEstado){
        thread = new Thread(){
            public void run(){
                try {
                    StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
                    StrictMode.setThreadPolicy(policy);

                    SoapObject Request = new SoapObject(NAMESPACE, "GetCasos");
                    Request.addProperty("nt", ntUser);
                    Request.addProperty("idEstado", idEstado);

                    SoapSerializationEnvelope soapEnvelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
                    soapEnvelope.dotNet = true;
                    soapEnvelope.setOutputSoapObject(Request);
                    transporte.call(SOAP_ACTION, soapEnvelope);

                    final SoapObject resultSoap = (SoapObject) soapEnvelope.getResponse();
                    String aplications = "";
                    for (int i = 0 ; i<resultSoap.getPropertyCount(); i++){
                        if (resultSoap.hasProperty("GetCasosPendientes_Result")) {
                            SoapObject soapObject1 = (SoapObject) resultSoap.getProperty(i);
                            if (soapObject1.hasProperty("Aplicacion")) {
                                aplications += soapObject1.getProperty("Aplicacion").toString() +" | ";
                            }
                        }
                    }
                    //res = resultSoap.getProperty(0).toString();
                    //res +=" mensaje: " + resultSoap.getProperty(1).toString();
                    //res += " agenda: " + resultSoap.getProperty(2) == null ? "" : resultSoap.getProperty(2).toString();
                    res = resultSoap.toString() + " Apps: " + aplications;
                }
                catch(Exception e){
                    res = e.getMessage().toString();
                }
                handler.post(createUI);
            }
        };

        thread.start();
    }*/

    final Runnable createUI = new Runnable() {
        public void run(){
            //tvwResultado.setText("" + res);
            String Tickets = "";
            for (String item:listDataHeader) {
                Tickets += item +", ";
            }
            tvwResultado.setText("" + Tickets);
        }
    };

}

