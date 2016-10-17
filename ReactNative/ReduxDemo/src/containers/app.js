/**
 * Created by xudosom on 2016/10/17.
 */

import React, {Component} from 'react';
import {
    StyleSheet,
    TextInput,
    Text,
    View,
    Image,
    TouchableHighlight,
    ActivityIndicator,
}from 'react-native';

import {connect} from 'react-redux';
import {bindActionCreator} from 'redux';
import * as actionCreators from '../actions/login';
import Modal from 'react-native-modalbox';

class Login extends Component {
    constructor(props) {
        super(props);
        this.state = {
            'password': '',
            'phone': '',
        };
        this.login = this.login.bind(this);
        this.onChangePhone = this.onChangePhone.bind(this);
        this.onChangePassword = this.onChangePassword.bind(this);

    };


    login() {
        if (!this.state.phone || !this.state.password) {
            alert("用户名和密码不能为空")
        } else {
            this.refs.modal.open();
            this.props.actions.login({'phone': this.state.phone, 'password': this.state.password});
        }
    };

    onChangePhone(text) {
        this.setState({
            'phone': text,
        });
    };

    onChangePassword(text) {
        this.setState({
            'password': text,
        });
    };


    render() {
        console.log('render...');
        return (
            <View style={{flex: 1}}>
                <View style={{padding: 20, marginTop: 50}}>
                    <View style={styles.item}><Text style={{width: 70}}>手机号码</Text>
                        <TextInput
                            style={styles.input}
                            onChangeText={this.onChangePhone}
                            placeholder='请输入手机号码'
                            value={this.state.phone}
                        />
                    </View>
                    <View style={styles.item}>
                        <Text style={{width: 70}}>密码</Text>
                        <TextInput
                            style={styles.input}
                            onChangeText={this.onChangePswd}
                            placeholder='请输入密码'
                            password={true}
                            value={this.state.password}
                        />
                    </View>

                    <TouchableHighlight style={styles.button}
                                        underlayColor='#000000' onPress={this.login}>
                        <Text style={{fontSize: 16, color: '#fff'}}>登陆</Text>
                    </TouchableHighlight>
                </View>

                <Modal
                    style={styles.modal}
                    ref='modal'
                    isOpen={this.props.status == 'doing' ? true : false}
                    animationDuration={0}
                    position={"center"}
                >
                    <ActivityIndicator
                        size='large'
                    />
                    <Text style={{marginTop: 15, fontSize: 16, color: '#444444'}}>登陆中...</Text>
                </Modal>
            </View>
        );
    };
}
;

const styles = StyleSheet.create({
    item: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center',
        height: 50,
        borderBottomColor: '#ddd',
        borderBottomWidth: 1,
    },
    input: {
        flex: 1,
        fontSize: 14,
    },
    button: {
        backgroundColor: '#1a191f',
        height: 50,
        marginTop: 40,
        justifyContent: 'center',
        alignItems: 'center'
    },
    modal: {
        justifyContent: 'center',
        alignItems: 'center',
        width: 150,
        height: 150,
        borderRadius: 10,
    },
});


function mapStateToProps(state) {
    return {
        'isLoginedIn': state.user.isLoginedIn,
        'status': state.user.status,
    };
};
function mapDispathToProps(dispath) {
    return {
        'actions': bindActionCreator(actionCreators, dispath),
    };
};

export  default connect(mapStateToProps, mapDispathToProps)(Login);