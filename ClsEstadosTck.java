package com.example.jcanas.helpdesk;

/**
 * Created by JCANAS on 29/08/2016.
 */
public class ClsEstadosTck {

    public String idEstado, estado;
    public ClsEstadosTck(String _idEstado, String _estado)
    {
        idEstado =_idEstado;
        estado = _estado;
    }
    public String toString()
    {
        return estado;
    }

}
